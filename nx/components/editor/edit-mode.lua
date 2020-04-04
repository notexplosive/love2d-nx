local sceneLayers = require("nx/scene-layers")
local EditMode = {}

registerComponent(EditMode, "EditMode")

function EditMode:awake()
    local debugScene = sceneLayers:peek()
    local iconActor = debugScene:addActor()
    iconActor:addComponent(Components.BoundingBox, 32, 48)
    iconActor:addComponent(Components.EditorRibbon)
    iconActor:addComponent(Components.EditorRibbonBackground)
    iconActor:addComponent(Components.EaseFromTo, Vector.new(0, -iconActor.BoundingBox:height()), Vector.new(0, 0))
    iconActor:addComponent(Components.BoundingBoxToSceneWidth)

    self.icon = iconActor

    self.actor:addComponentSafe(Components.Uneditable)
    self.actor:addComponent(Components.Selector)
    self.actor:addComponent(Components.MiddleMousePan)
    self.actor:addComponent(Components.SpawnMousePointer)

    self:makeAllObjectsEditable()
end

function EditMode:update(dt)
    self:makeAllObjectsEditable()
end

function EditMode:onDestroy()
    for i, actor in self.actor:scene():eachActorWith(Components.Editable) do
        actor:removeComponent(Components.Editable)
    end

    self.icon:destroy()
end

function EditMode:makeAllObjectsEditable()
    for i, actor in ipairs(self.actor:scene():getAllActors()) do
        if not actor.Uneditable and not actor.Editable then
            actor:addComponent(Components.Editable)
        end
    end
end

return EditMode
