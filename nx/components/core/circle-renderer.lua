local CircleRenderer = {}

registerComponent(CircleRenderer, "CircleRenderer")

function CircleRenderer:setup(radius, color)
    self.radius = radius
    self.color = color
end

function CircleRenderer:BoundingBox_deferredSetup()
    self.actor.BoundingBox:setup(self.radius * 2, self.radius * 2, self.radius, self.radius)
end

function CircleRenderer:draw(x, y)
    love.graphics.setColor(self.color or {1, 1, 1, 1})
    love.graphics.circle("fill", x, y, self.radius)

    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.circle("line", x, y, self.radius)
end

return CircleRenderer
