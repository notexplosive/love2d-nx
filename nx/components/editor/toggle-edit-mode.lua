local ToggleEditMode = {}

registerComponent(ToggleEditMode, "ToggleEditMode")

function ToggleEditMode:awake()
    self.actor:addComponentSafe(Components.TrackModifierKeys)
end

function ToggleEditMode:onKeyPress(key, scancode, wasRelease)
    if key == "e" and not wasRelease and ALLOW_DEBUG and self.actor.TrackModifierKeys.ctrl then
        local editModeActor = self.actor:scene():getFirstActorWithIfExists(Components.EditMode)
        if not editModeActor then
            editModeActor = self.actor:scene():addActor("EditMode")
            editModeActor:addComponent(Components.EditMode)
        else
            editModeActor.EditMode:destroy()
        end

        self.actor:scene():consumeKeyPress()
    end
end

return ToggleEditMode
