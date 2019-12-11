local RotateTowardsActor = {}

registerComponent(RotateTowardsActor, "RotateTowardsActor")

function RotateTowardsActor:setup(targetActor, ...)
    self.targetActor = targetActor
    if ... then
        self.actor.RotateTowardsPoint:setup(...)
    end
end

function RotateTowardsActor:awake()
    self.targetActor = nil
    self.actor:addComponent(Components.RotateTowardsPoint)
end

function RotateTowardsActor:start()
    assert(self.targetActor, "targetActor not initialized in RotateTowardsActor")
end

function RotateTowardsActor:update(dt)
    self.actor.RotateTowardsPoint.target = self.targetActor:pos()
end

return RotateTowardsActor
