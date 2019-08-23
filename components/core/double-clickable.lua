local DoubleClickable = {}

registerComponent(DoubleClickable, "DoubleClickable", {"Clickable"})

local doubleClickDelay = 0.5

function DoubleClickable:awake()
    self.timer = 0
    self.cooldown = 0
end

function DoubleClickable:Clickable_onClickOn(button)
    if self.cooldown > 0 then
        return
    end

    if self.timer > 0 then
        self.actor:callForAllComponents("DoubleClickable_onDoubleClick", button)
        self.timer = 0
        self.cooldown = 0.25
    else
        self.timer = doubleClickDelay
    end
end

function DoubleClickable:update(dt)
    if self.timer > 0 then
        self.timer = self.timer - dt
    end

    if self.cooldown > 0 then
        self.cooldown = self.cooldown - dt
    end
end

return DoubleClickable
