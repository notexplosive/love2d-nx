local Selector = {}

registerComponent(Selector, "Selector")

function Selector:awake()
    self.selectedActors = {}
end

--
-- Public API
--

function Selector:selectActor(actor)
    assert(actor, "Actor cannot be nil")
    if not self:isActorSelected(actor) then
        append(self.selectedActors, actor)
    end
end

function Selector:deselectActor(actor)
    assert(actor, "Actor cannot be nil")
    deleteFromList(self.selectedActors, actor)
end

function Selector:isActorSelected(actor)
    assert(actor, "Actor cannot be nil")
    return indexOf(self.selectedActors, actor) ~= nil
end

function Selector:getAllSelectedActors()
    return copyList(self.selectedActors)
end

return Selector
