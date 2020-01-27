local ToggleEditMode = {}

registerComponent(ToggleEditMode, "ToggleEditMode")

function ToggleEditMode:awake()
    self.actor:addComponentSafe(Components.TrackModifierKeys)
end

function ToggleEditMode:onKeyPress(key, scancode, wasRelease)
    if key == "e" and wasRelease and ALLOW_DEBUG and self.actor.TrackModifierKeys.ctrl then
        local editModeActor = gameScene:getFirstActorWith(Components.EditMode)
        if not editModeActor then
            editModeActor = gameScene:addActor("EditMode")
            editModeActor:addComponent(Components.EditMode)
        else
            editModeActor:destroy()
        end
    end
end

return ToggleEditMode
