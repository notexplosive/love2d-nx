local Body = {}

registerComponent(Body, "Body")

function Body:setup(bodyType, _startingMass)
    local x, y = self.actor:pos():xy()
    self.world = self.actor:scene():getFirstBehavior(Components.World)()
    self.body = love.physics.newBody(self.world, x, y, bodyType)
    self.body:setAngle(self.actor:angle())

    -- overwrite actor natives
    local body = self.body
    local oldSetPos = self.actor.setPos
    function self.actor:setPos(v, y)
        oldSetPos(self, v, y)
        local pos = Vector.new(v, y)
        body:setPosition(pos.x, pos.y)
    end

    --[[
    function self.actor:pos()
        return body:getPosition()
    end
    ]]
    local oldSetAngle = self.actor.setAngle
    function self.actor:setAngle(angle)
        oldSetAngle(self, angle)
        body:setAngle(angle)
    end

    if _startingMass then
        self:setMass(_startingMass)
    end
end

function Body:draw(x, y)
end

function Body:update(dt)
    self.actor:setPos(self.body:getPosition())
    self.actor:setAngle(self.body:getAngle())
end

function Body:onKeyPress(key, scancode, wasRelease)
    if key == "space" and wasRelease then
        self.actor:setPos(200, 200)
    end
end

--
-- api
--

function Body:__call()
    return self.body
end

function Body:getLinearVelocity()
    return self.body:getLinearVelocity()
end

function Body:setLinearVelocity(v, y)
    local vec = Vector.new(v, y)
    self.body:setLinearVelocity(vec.x, vec.y)
end

function Body:applyForce(v, y)
    local vec = Vector.new(v, y)
    self.body:applyForce(vec.x, vec.y)
end

function Body:getMass()
    return self.body:getMass()
end

function Body:setMass(mass)
    self.body:setMass(mass)
end

return Body
