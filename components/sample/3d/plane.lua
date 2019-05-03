local Plane = {}

registerComponent(Plane, "Plane")

function Plane:awake()
end

function Plane:draw(x, y)
    local depthScale = 0.85
    -- Primary width is the width of the "Front"
    local primaryWidth = 64
    -- Secondary width is the width of the "Back"
    local secondaryWidth = primaryWidth * depthScale

    local distanceFromCenterX = love.graphics.getWidth()/2 - x

    local horizontalScale = 0.1

    local primaryY = (y - love.graphics.getHeight()/2)
    local secondaryY = primaryY * depthScale

    local points = {
        x - primaryWidth / 2,
        primaryY,
        x + primaryWidth / 2,
        primaryY,
        x + secondaryWidth / 2 + distanceFromCenterX * horizontalScale,
        secondaryY,
        x - secondaryWidth / 2 + distanceFromCenterX * horizontalScale,
        secondaryY
    }

    for i = 1, #points, 2 do
        local px = points[i]
        local py = points[i + 1]
        points[i] = points[i] + primaryWidth / 2
        points[i + 1] = points[i + 1] + love.graphics.getHeight()/2
    end


    if primaryY > secondaryY then
        love.graphics.setColor(1,1,1)
    else
        love.graphics.setColor(1,0,1)
    end

    love.graphics.polygon(
        "fill",
        unpack(points)
    )
end

return Plane
