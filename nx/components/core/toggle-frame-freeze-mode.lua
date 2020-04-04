local ToggleFrameFreezeMode = {}

registerComponent(ToggleFrameFreezeMode, "ToggleFrameFreezeMode")

function ToggleFrameFreezeMode:onKeyPress(button, scancode, wasRelease)
    if ALLOW_DEBUG then
        if button == "lctrl" or button == "rctrl" then
            self.ctrlDown = not wasRelease
        end

        assert(
            not self.actor:scene():getFirstBehaviorIfExists(Components.FrameFreezeListener),
            "Scene has both ToggleFrameFreezeMode and FrameFreezeListener. A given scene needs to have one or the other"
        )

        if self.ctrlDown and not wasRelease and button == "space" then
            if not self.freezeActor then
                self.freezeActor = self.actor:scene():addActor()
                self.freezeActor.name = "FrameFreeze"
                self.freezeActor:addComponent(Components.FrameFreezeMode)
            else
                self.freezeActor.FrameFreezeMode:destroy()
                self.freezeActor = nil
            end
        end
    end
end

return ToggleFrameFreezeMode
