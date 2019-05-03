local Plane = {}

registerComponent(Plane, "Plane")

function Plane:awake()
end

function Plane:draw(x, y)
    local depthScale = 0.75
    -- Primary width is the width of the "Front"
    local primaryWidth = 50
    -- Secondary width is the width of the "Back"
    local secondaryWidth = 50 * depthScale

    love.graphics.line(x - primaryWidth / 2, y*0.9, x + primaryWidth / 2, y*0.9)
    love.graphics.line(x - secondaryWidth / 2, y * 2, x + secondaryWidth / 2, y * 2)

    --[[
    love.graphics.polygon(
        "line",
        x - widthFront + 10 * horizAngle,
        y - fov * vertAngle,
        --
        x + widthFront + 10 * horizAngle,
        y - fov * vertAngle,
        --
        x - 100 + 10 * horizAngle,
        y + fov * vertAngle,
        --
        x - 100 + 10 * horizAngle,
        y + fov * vertAngle
    )
    ]]
end

function Plane:update(dt)
end

return Plane
