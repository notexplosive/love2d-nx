local Editable = {}

registerComponent(Editable, "Editable")

function Editable:awake()
    self.componentsAddedByMe = {}
    self.componentsRemovedByMe = {}

    self:addComponentSafe(Components.BoundingBox)

    if self.actor.SpriteRenderer then
        self.actor.SpriteRenderer:setupBoundingBox()
    end

    if self.actor.WorldDrag then
        self:removeComponent(Components.Draggable)
        self:removeComponent(Components.Clickable)
        self:removeComponent(Components.Hoverable)
    else
        --self:addComponentSafe(Components.NameRenderer)
        self:addComponentSafe(Components.Hoverable)
        self:addComponentSafe(Components.Clickable)
        self:addComponentSafe(Components.Draggable)
        self:addComponentSafe(Components.MoveOnDrag)
        self:addComponentSafe(Components.Selectable)

        self:addComponentSafe(Components.Keybind)
        self:addComponentSafe(Components.Duplicatable, "^d")
        self:addComponentSafe(Components.Destroyable, "delete")

        if self.actor.AngleEditable then
            self:addComponentSafe(Components.AngleEditor)
        end

        self:addComponentSafe(Components.HoverableRenderer)
    end
end

function Editable:Selectable_onSelect()
    if self.actor.NinePatch then
        self.actor:addComponentSafe(Components.BoundingBoxEditor)
    end

    local ribbon = uiScene:getFirstBehavior(Components.EditorRibbon)
    if ribbon then
        ribbon:onActorSelect(self.actor)
    end
end

function Editable:Selectable_onDeselect()
    self.actor:removeComponentSafe(Components.BoundingBoxEditor)
end

function Editable:onDestroy()
    for i, componentClass in ipairs(copyReversed(self.componentsAddedByMe)) do
        self.actor:removeComponent(componentClass)
    end

    for i, componentClass in ipairs(copyReversed(self.componentsRemovedByMe)) do
        self.actor:addComponent(componentClass)
    end
end

function Editable:addComponent(componentClass, ...)
    append(self.componentsAddedByMe, componentClass)
    self.actor:addComponent(componentClass, ...)
end

function Editable:removeComponent(componentClass)
    assert(self.actor[componentClass.name], "Cannot remove a component that does not exist")
    append(self.componentsRemovedByMe, componentClass)
    self.actor:removeComponent(componentClass)
end

function Editable:addComponentSafe(componentClass, ...)
    if self.actor[componentClass.name] then
        return
    end

    self:addComponent(componentClass, ...)
end

return Editable
