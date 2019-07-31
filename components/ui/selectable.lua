local Selectable = {}

registerComponent(Selectable, "Selectable", {"Clickable"})

function Selectable:draw(x, y)
    love.graphics.setColor(1, 0.5, 0)
    if self:selected() then
        local rect = self.actor.BoundingBox:getRect()
        rect:inflate(16,16)
        love.graphics.rectangle("line", rect:xywh())
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

function Selectable:getSelector()
    return gameScene:getFirstBehavior(Components.Selector)
end

function Selectable:deselectAll()
    for i, actor in ipairs(self:getSelector():getAllSelectedActors()) do
        actor.Selectable:deselect()
    end
end

--
-- Public API
--

function Selectable:selected()
    return self:getSelector():isActorSelected(self.actor)
end

function Selectable:select(forceGroupSelect)
    local groupSelect = forceGroupSelect
    if not groupSelect then
        self:deselectAll()
    end

    self:getSelector():selectActor(self.actor)

    self.actor:callForAllComponents("Selectable_onSelect")
end

function Selectable:deselect()
    if self:selected() then
        self:getSelector():deselectActor(self.actor)
        self.actor:callForAllComponents("Selectable_onDeselect")
    end
end

function Selectable:getAllSelectedActors()
    return self:getSelector():getAllSelectedActors()
end

return Selectable
