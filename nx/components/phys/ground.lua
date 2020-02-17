local Ground = {}

registerComponent(Ground, "Ground")

function Ground:awake()
    self.world = self.actor:scene():getFirstBehavior(Components.World)()
    self.actor:setPos(650 / 2, 650 - 50 / 2)
    local x, y = self.actor:pos():xy()

    self.bodyPos = Vector.new(x, y)

    self.body = love.physics.newBody(self.world, self.bodyPos.x, self.bodyPos.y) --remember, the shape (the rectangle we create next) anchors to the body from its center, so we have to move it to (650/2, 650-50/2)
    self.shape = love.physics.newRectangleShape(650, 50) --make a rectangle with a width of 650 and a height of 50
    self.fixture = love.physics.newFixture(self.body, self.shape) --attach shape to body
end

function Ground:draw(x, y)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.polygon("fill", self.body:getWorldPoints(self.shape:getPoints()))
end

function Ground:update(dt)
    self.actor:setPos(self.body:getPosition())
end

return Ground
