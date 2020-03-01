local CircleShape = {}

registerComponent(CircleShape, "CircleShape", {"Body"})

function CircleShape:setup(radius, _density)
    assert(radius)
    self.shape = love.physics.newCircleShape(radius)
    self.fixture = love.physics.newFixture(self.actor:Body(), self.shape, _density or 1)

    self.actor:addComponentSafe(Components.Fixtures, self.fixture)
end

function CircleShape:draw(x, y)
    if DEBUG then
        love.graphics.setColor(1, 0.5, 0.5, 1)
        love.graphics.circle("line", x, y, self.shape:getRadius())
    end
end

return CircleShape
