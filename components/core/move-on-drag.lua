local MoveOnDrag = {}

registerComponent(MoveOnDrag, "MoveOnDrag", {"Draggable"})

function MoveOnDrag:Draggable_onDrag(x, y, dx, dy)
    self:moveBy(dx, dy)

    if self.actor.Selectable then
        for i, actor in ipairs(self.actor.Selectable:getAllSelectedActors()) do
            if actor.MoveOnDrag and actor ~= self.actor then
                actor.MoveOnDrag:moveBy(dx, dy)
            end
        end
    end
end

function MoveOnDrag:moveBy(dx, dy)
    local p = self.actor:pos()
    self.actor:setPos(Vector.new(math.floor(p.x), math.floor(p.y)))
    self.actor:move(Vector.new(dx, dy))
end

return MoveOnDrag
