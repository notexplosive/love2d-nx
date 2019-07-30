local SelectionState = {}

registerComponent(SelectionState, "SelectionState")

function SelectionState:awake()
    self.selectedActors = {}
end

--
-- Public API
--

function SelectionState:selectActor(actor)
    assert(actor, "Actor cannot be nil")
    if not self:isActorSelected(actor) then
        append(self.selectedActors, actor)
    end
end

function SelectionState:deselectActor(actor)
    assert(actor, "Actor cannot be nil")
    deleteFromList(self.selectedActors, actor)
end

function SelectionState:isActorSelected(actor)
    assert(actor, "Actor cannot be nil")
    return indexOf(self.selectedActors, actor) ~= nil
end

function SelectionState:getAllSelectedActors()
    return copyList(self.selectedActors)
end

return SelectionState
