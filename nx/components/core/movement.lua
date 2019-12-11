local Movement = {}

registerComponent(Movement, "Movement")

function Movement:setup(v, y)
    self.velocity = Vector.new(v, y)
    self.isFrozen = false
end

function Movement:awake()
    self.velocity = Vector.new()
    self.ignoreTimescale = false
end

function Movement:update(dt)
    if not self.isFrozen then
        self.actor:setPos(self.actor:pos() + self.velocity * dt * 60)
    end
end

--
-- public api
--

function Movement:freeze()
    self.velocity = Vector.new(0, 0)
    self.isFrozen = true
end

function Movement:unfreeze()
    self.isFrozen = false
end

function Movement:applyForce(force)
    if not self.isFrozen then
        self.velocity = self.velocity + force * self:getTimeScale()
    end
end

function Movement:getTimeScale()
    if not self.ignoreTimescale then
        return getTimeScale()
    else
        return 1
    end
end

return Movement
