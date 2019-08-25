local Oscillate = {}

registerComponent(Oscillate, "Oscillate")

function Oscillate:awake()
    self.time = 0
end

function Oscillate:update(dt)
    self.time = self.time + dt/2
    self.actor:setPos((math.sin(self.time) + 1) * self.actor:scene().width / 2, 50)
end

return Oscillate
