local Selectable = {}

registerComponent(Selectable, "Selectable", {"Clickable"})

function Selectable:draw(x, y)
    love.graphics.setColor(1, 0.5, 0)
    if self:selected() then
        local x, y, w, h = self.actor.BoundingBox:getRect()
        love.graphics.rectangle("line", x - 2, y - 2, w + 4, h + 4)
    end
end

function Selectable:Clickable_onClickOn(button)
    if button == 1 and not self:selected() then
        self:select()
    end
end

function Selectable:Draggable_onDragStart()
    if not self:selected() then
        self:select()
    end
end

function Selectable:getSelectionState()
    return gameScene:getFirstBehavior(Components.SelectionState)
end

function Selectable:deselectAll()
    for i, actor in ipairs(self:getSelectionState():getAllSelectedActors()) do
        actor.Selectable:deselect()
    end
end

--
-- Public API
--

function Selectable:selected()
    return self:getSelectionState():isActorSelected(self.actor)
end

function Selectable:select(forceGroupSelect)
    local groupSelect = forceGroupSelect
    if not groupSelect then
        self:deselectAll()
    end

    self:getSelectionState():selectActor(self.actor)

    self.actor:callForAllComponents("Selectable_onSelect")
end

function Selectable:deselect()
    if self:selected() then
        self:getSelectionState():deselectActor(self.actor)
        self.actor:callForAllComponents("Selectable_onDeselect")
    end
end

function Selectable:getAllSelectedActors()
    return self:getSelectionState():getAllSelectedActors()
end

return Selectable
