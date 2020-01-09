local MoveOnDrag = {}

registerComponent(MoveOnDrag, "MoveOnDrag")

function MoveOnDrag:Draggable_onDrag(x, y, newX, newY, dx, dy)
    local displacement = Vector.new(dx, dy)
    local newPos = self.actor:pos() + displacement
    self:moveTo(newPos)

    if self.actor.Selectable then
        for i, actor in ipairs(self.actor.Selectable:getAllSelectedActors()) do
            -- skip first actor because it's already being dragged
            if i ~= 1 then
                if actor.MoveOnDrag and actor ~= self.actor then
                    actor.MoveOnDrag:moveTo(newPos)
                end
            end
        end
    end
end

function MoveOnDrag:moveTo(v, y)
    local vec = Vector.new(v, y)
    self.actor:setPos(vec)
end

return MoveOnDrag
