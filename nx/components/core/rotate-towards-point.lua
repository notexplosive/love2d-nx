local RotateTowardsPoint = {}

registerComponent(RotateTowardsPoint, "RotateTowardsPoint")

function RotateTowardsPoint:setup(angleOffset, target, friction)
    self.angleOffset = angleOffset or self.angleOffset
    self.target = target or Vector.new()
    self.friction = friction or 1
end

function RotateTowardsPoint:reverseSetup()
    return self.angleOffset, self.target, self.friction
end

function RotateTowardsPoint:awake()
    self.angleOffset = -math.pi / 2
    self.target = Vector.new()
    self.friction = 4
end

function RotateTowardsPoint:update(dt)
    local displacementToTarget = self.target - self.actor:pos()
    local myAngleAsVector = Vector.newPolar(1, self.actor:angle() + self.angleOffset)
    local newVector = myAngleAsVector + displacementToTarget:normalized() / self.friction

    self.actor:setAngle(newVector:angle() - self.angleOffset)
end

return RotateTowardsPoint
