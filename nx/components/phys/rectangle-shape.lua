local RectangleShape = {}

registerComponent(RectangleShape, "RectangleShape")

function RectangleShape:setup(width, height, density)
    self.shape = love.physics.newRectangleShape(width, height)
    self.fixture = love.physics.newFixture(self.actor:Body(), self.shape, density or 1)

    self.actor:addComponentSafe(Components.Fixtures, self.fixture)
end

function RectangleShape:draw(x, y)
    if DEBUG then
        love.graphics.setColor(1, 1, 0.5, 1)
        love.graphics.polygon("line", self.actor:Body():getWorldPoints(self.shape:getPoints()))
    end
end

return RectangleShape
