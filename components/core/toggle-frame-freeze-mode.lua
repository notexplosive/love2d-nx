local ToggleFrameFreezeMode = {}

registerComponent(ToggleFrameFreezeMode, "ToggleFrameFreezeMode")

function ToggleFrameFreezeMode:onKeyPress(button, scancode, wasRelease)
    if button == "lctrl" or button == "rctrl" then
        self.ctrlDown = not wasRelease
    end

    if self.ctrlDown and not wasRelease and button == "space" and ALLOW_FRAME_FREEZE then
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
