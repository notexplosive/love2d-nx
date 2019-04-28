local Plane = {}

registerComponent(Plane, "Plane")

function Plane:awake()
end

function Plane:draw(x, y)
    love.graphics.circle("line", x, y, 30)

    local fov = 180
    local widthFront = 80
    local vertAngle = (self.actor:pos().y - love.graphics.getHeight() / 2) / love.graphics.getHeight()
    local horizAngle = (self.actor:pos().x - love.graphics.getWidth() / 2) / love.graphics.getWidth()
    print(vertAngle,horizAngle)
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
end

function Plane:update(dt)
end

return Plane
