local Movement = {}

registerComponent(Movement, "Movement")

function Movement:setup(v, y)
    self.velocity = Vector.new(v, y)
    self.isFrozen = false
end

function Movement:awake()
    self.velocity = Vector.new()
    self.displacement = Vector.new()
    self.ignoreTimescale = false
end

function Movement:update()
    if not self.isFrozen then
        self.displacement = self.velocity * (self:getTimeScale() + 0.00035)
        self.actor:setPos(self.actor:pos() + self.displacement)
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

-- How much did the object move this frame?
function Movement:getDisplacement()
    return self.displacement:clone()
end

function Movement:getTimeScale()
    if not self.ignoreTimescale then
        return getTimeScale()
    else
        return 1
    end
end

return Movement
