local MoveAlongAngle = {}

registerComponent(MoveAlongAngle,'MoveAlongAngle')

function MoveAlongAngle:setup(speed)
    self.speed = speed or self.speed
end

function MoveAlongAngle:reverseSetup()
    return self.speed
end

function MoveAlongAngle:awake()
    self.speed = 1
    self.angleOffset = -math.pi/2
end

function MoveAlongAngle:update(dt)
    self.actor:move(Vector.newPolar(self.speed,self.actor:angle()+self.angleOffset))
end

return MoveAlongAngle