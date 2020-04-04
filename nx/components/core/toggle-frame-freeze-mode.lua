local ToggleFrameFreezeMode = {}

registerComponent(ToggleFrameFreezeMode, "ToggleFrameFreezeMode")

function ToggleFrameFreezeMode:onKeyPress(button, scancode, wasRelease)
    if ALLOW_DEBUG then
        if button == "lctrl" or button == "rctrl" then
            self.ctrlDown = not wasRelease
        end

        assert(
            not self.actor:scene():getFirstBehaviorIfExists(Components.SceneCanBeFrameFrozen),
            "Scene has both ToggleFrameFreezeMode and SceneCanBeFrameFrozen. A given scene needs to have one or the other"
        )

        if self.ctrlDown and not wasRelease and button == "space" then
            if not self.freezeActor then
                self.freezeActor = self.actor:scene():addActor()
                self.freezeActor:addComponent(Components.FrameFreezeMode)
            else
                self.freezeActor:destroy()
                self.freezeActor = nil
            end
        end
    end
end

return ToggleFrameFreezeMode
