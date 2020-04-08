local sceneLayers = require("nx/scene-layers")
local EditMode = {}

registerComponent(EditMode, "EditMode")

function EditMode:awake()
    self.actor:addComponent(Components.SidebarIcon)
    self.actor:addComponent(Components.SpriteRenderer, "linkin", "stand", 4)

    self.actor:addComponentSafe(Components.Uneditable)
    self.actor:addComponent(Components.SpawnMousePointer)

    self:makeAllObjectsEditable()
end

function EditMode:update(dt)
    self:makeAllObjectsEditable()
end

function EditMode:onDestroy()
    for _, scene in sceneLayers:each() do
        local listener = scene:getFirstBehaviorIfExists(Components.EditModeListener)
        if listener then
            listener:disableEditor()
        end
    end

    self.actor.SidebarIcon:retract()
end

function EditMode:makeAllObjectsEditable()
    for _, scene in sceneLayers:each() do
        local listener = scene:getFirstBehaviorIfExists(Components.EditModeListener)
        if listener then
            listener:enableEditor()
        end
    end
end

return EditMode
