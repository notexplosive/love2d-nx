local Children = {}

registerComponent(Children,'Children')

-- This is the list of children owned by the PARENT

function Children:setup(childActor)
    self:add(childActor)
end

function Children:awake()
    self.list = {}
end

function Children:add(childActor)
    append(self.list,childActor)
end

function Children:remove(actor)
    deleteFromList(self.list, actor)
end

function Children:get()
    return copyList(self.list)
end

function Children:onDestroy()
    for i, childActor in ipairs(self.list) do
        if not childActor.isDestroyed then
            childActor:destroy()
        end
    end
end

function Children:onBringToFront()
    for i, childActor in ipairs(self:get()) do
        self.actor:scene():bringToFront(childActor)
    end
end

function Children:onSendToBack()
    -- this might be wrong
    for i, childActor in ipairs(self:get()) do
        --self.actor:scene():sendToBack(childActor)
    end
end

return Children