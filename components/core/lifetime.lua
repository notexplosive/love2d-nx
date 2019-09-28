local Lifetime = {}

registerComponent(Lifetime, "Lifetime")

function Lifetime:setup(time)
    self.time = time
    self.totalTime = time
    self.timeScale = uiScene:getFirstBehavior(Components.TimeScale)
end

function Lifetime:reverseSetup()
    -- note: returns self.time, not self.totalTime
    return self.time
end

function Lifetime:update(dt)
    local ddt = dt * self.actor.TimeScaleListener:get()
    self.time = self.time - ddt

    if self.time < 0 then
        self.actor:destroy()
    end
end

function Lifetime:percent()
    return 1 - self.time / self.totalTime
end

return Lifetime
