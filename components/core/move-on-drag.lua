local MoveOnDrag = {}

registerComponent(MoveOnDrag, "MoveOnDrag")

function MoveOnDrag:Draggable_onDrag(x, y, dx, dy)
    self:moveTo(dx, dy)

    if self.actor.Selectable then
        for i, actor in ipairs(self.actor.Selectable:getAllSelectedActors()) do
            if actor.MoveOnDrag and actor ~= self.actor then
                actor.MoveOnDrag:moveTo(dx, dy)
            end
        end
    end
end

function MoveOnDrag:moveTo(x,y)
    self.actor:setPos(x,y)
end

return MoveOnDrag
