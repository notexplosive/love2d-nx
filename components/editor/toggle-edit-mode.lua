local ToggleEditMode = {}

registerComponent(ToggleEditMode, "ToggleEditMode")

function ToggleEditMode:onKeyPress(key, scancode, wasRelease)
    if key == "e" and wasRelease then
        local editModeActor = gameScene:getFirstActorWith(Components.EditMode)
        if not editModeActor then
            editModeActor = gameScene:addActor('EditMode')
            editModeActor:addComponent(Components.EditMode)
        else
            editModeActor:destroy()
        end
    end
end

return ToggleEditMode
