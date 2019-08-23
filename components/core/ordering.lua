local Ordering = {}

registerComponent(Ordering,'Ordering')

function Ordering:bringToFront()
    if self.actor.Parent then
        self.actor:scene():bringToFront(self.actor.Parent:getRoot())
    else
        self.actor:scene():bringToFront(self.actor)
    end
end

function Ordering:sendToBack()
    if self.actor.Children then
        for i, childActor in ipairs(self.actor.Children:get()) do
            self.actor:scene():sendToBack(childActor)
        end
    end
    
    self.actor:scene():sendToBack(self.actor)

    if self.actor.Parent then
        self.actor:scene():sendToBack(self.actor.Parent:getRoot())
    end
end

return Ordering