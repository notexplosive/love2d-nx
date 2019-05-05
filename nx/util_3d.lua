G_FOV = 60
local tanFov = 1 / math.tan(G_FOV/2)

function projectToScreenCoordinates(x,y,z)
    local near = 0.1
    local far = 1000

    local aspectRatio = love.graphics.getWidth() / love.graphics.getHeight()
    local px = tanFov * x / z * love.graphics.getWidth()/2  + love.graphics.getWidth()/2
    local py = tanFov * y / z * love.graphics.getHeight()/2  + love.graphics.getWidth()/2

    print(px,py)
    return -px,-py
end

local nearPlane = 10
local farPlane = 1000
local projectionMatrix = {
    {0,0,0,0},
    {0,0,0,0},
    {0,0,0,0},
    {0,0,0,0}
}
--TODO: need to recalc on resize
projectionMatrix[1][1] = love.graphics.getWidth() / love.graphics.getHeight() * tanFov
projectionMatrix[2][2] = tanFov
projectionMatrix[3][3] = farPlane / (farPlane - nearPlane)
projectionMatrix[4][3] = (-farPlane * nearPlane) / (farPlane - nearPlane)
projectionMatrix[3][4] = 1


function v3timesMatrix(x,y,z, matrix)
    local rx,ry,rz

    rx = x * matrix[1][1] + y * matrix[2][1] + z * matrix[3][1] + matrix[4][1]
    ry = x * matrix[1][2] + y * matrix[2][2] + z * matrix[3][2] + matrix[4][2]
    rz = x * matrix[1][3] + y * matrix[2][3] + z * matrix[3][3] + matrix[4][3]
    local w = x * matrix[1][4] + y * matrix[1][3] + z * matrix[3][4] + matrix[4][4]

    if w ~= 0 then
        x = x/w
        y = y/w
        z = z/w
    end

    return rx,ry,rz
end

function project3D(x,y,z)
    local x,y = v3timesMatrix(x,y,z, projectionMatrix)
    x = x + 1 -- TODO: make this 2? 0.5??
    y = y + 1

    x = x * love.graphics.getWidth()
    y = y * love.graphics.getHeight()
end