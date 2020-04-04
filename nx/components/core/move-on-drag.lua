local MoveOnDrag = {}

registerComponent(MoveOnDrag, "MoveOnDrag")

function MoveOnDrag:Draggable_onDrag(x, y, newX, newY, dx, dy)
    local displacement = Vector.new(dx, dy)
    local newPos = self.actor:pos() + displacement
    self:moveTo(newPos)
end

function MoveOnDrag:moveTo(v, y)
    local vec = Vector.new(v, y)
    self.actor:setPos(vec)
end

return MoveOnDrag
