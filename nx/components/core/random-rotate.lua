local RandomRotate = {}

registerComponent(RandomRotate, "RandomRotate")

function RandomRotate:awake()
    self.theta = love.math.random() * (math.pi * 2) * 0.01
end

function RandomRotate:update(dt)
    self.actor:setAngle(self.actor:angle() + self.theta)
end

return RandomRotate
