local Parent = {}

registerComponent(Parent,'Parent')

-- This is the parent pointer held by the CHILD

function Parent:setup(actor)
    self.parentActor = actor
    self.parentActor:addComponentSafe(Components.Children, self.actor)
end

function Parent:update(dt)
    -- Maybe extract this into own component: MatchVisibilityOfParent
    -- Redundant for window canvas
    self.actor.visible = self.parentActor.visible
end

function Parent:get()
    return self.parentActor
end

function Parent:getRoot()
    local actor = self.actor
    while(actor.Parent) do
        actor = actor.Parent:get()
    end

    return actor
end

function Parent:onDestroy()
    if not self.parentActor.isDestroyed then
        self.parentActor.Children:remove(self.actor)
    end
end

return Parent