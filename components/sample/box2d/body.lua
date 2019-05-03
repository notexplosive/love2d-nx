local Body = {}

registerComponent(Body, "Body")

function Body:setup(bodyType)
    local pos = self.actor:pos()
    self.body = love.physics.newBody(self.actor:scene().world, pos.x, pos.y, bodyType)
    self.body:applyLinearImpulse(0,20)
    
end

function Body:draw(x, y)
end

function Body:update(dt)
    self.actor:setPos(self.body:getPosition())
    print(self.body:getPosition())
end

return Body
