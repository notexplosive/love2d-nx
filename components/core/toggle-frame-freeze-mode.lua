local ToggleFrameFreezeMode = {}

registerComponent(ToggleFrameFreezeMode, "ToggleFrameFreezeMode")

function ToggleFrameFreezeMode:onKeyPress(button, scancode, wasRelease)
    if not wasRelease and button == "space" and DEBUG then
        if not self.freezeActor then
            self.freezeActor = self.actor:scene():addActor()
            self.freezeActor:addComponent(Components.FrameFreezeMode)
        else
            self.freezeActor:destroy()
            self.freezeActor = nil
        end
    end
end

return ToggleFrameFreezeMode
