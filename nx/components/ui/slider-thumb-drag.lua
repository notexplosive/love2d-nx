local SliderThumbDrag = {}

registerComponent(SliderThumbDrag, "SliderThumbDrag", {"Parent", "AffixPos", "Draggable"})

function SliderThumbDrag:setup(numberOfIncrements)
    self.numberOfIncrements = numberOfIncrements
end

function SliderThumbDrag:Draggable_onDrag(x, y, newX, newY, dx, dy)
    local x = self.startingAffixedX + dx
    local max = self.actor.Parent:get().BoundingBox:getRect():width()
    x = clamp(x, 0, max)

    if self.numberOfIncrements then
        local percent = x / max
        x = x - (percent * max) % (max / self.numberOfIncrements)
    end

    self.actor.AffixPos.offset.x = x
end

function SliderThumbDrag:Draggable_onDragStart(x, y)
    self.startPos = Vector.new(x, y)
    self.startingAffixedX = self.actor.AffixPos.offset.x
end

function SliderThumbDrag:Draggable_onDragEnd()
    self.startPos = nil
    self.startingAffixedX = nil
end

return SliderThumbDrag
