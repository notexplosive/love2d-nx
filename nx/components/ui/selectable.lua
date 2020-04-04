local Selectable = {}

registerComponent(Selectable, "Selectable", {"BoundingBox"})

function Selectable:setup(suppressWarning, selected)
    if DEBUG then
        if not suppressWarning then
            debugLog("WARNING: Selectable shouldn't be used directly, call setup(true) if you know what you're doing")
        end
    end

    if selected then
        self:select()
    end
end

function Selectable:reverseSetup()
    return true, self:selected()
end

function Selectable:draw(x, y)
    love.graphics.setColor(1, 0.5, 0)
    if self:selected() then
        local rect = self.actor.BoundingBox:getRect()
        rect:inflate(8, 8)
        love.graphics.rectangle("line", rect:xywh())
    end
end

function Selectable:onDestroy()
    if self:selected() then
        self:deselect()
    end
end

function Selectable:Draggable_onDragStart()
    if not self:selected() then
        self:select()
    end
end

function Selectable:getSelector()
    local selector = self.actor:scene():getFirstBehavior(Components.Selector)
    assert(selector, "No Selector component")
    return selector
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
