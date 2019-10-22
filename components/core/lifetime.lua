local Lifetime = {}

registerComponent(Lifetime, "Lifetime")

function Lifetime:setup(time)
    self.time = time
    self.totalTime = time
end

function Lifetime:reverseSetup()
    -- note: returns self.time, not self.totalTime
    return self.time
end

function Lifetime:update(dt)
    self.time = self.time - dt

    if self.time < 0 then
        self.actor:destroy()
    end
end

function Lifetime:percent()
    return 1 - self.time / self.totalTime
end

return Lifetime
