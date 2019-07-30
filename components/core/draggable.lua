local Draggable = {}

registerComponent(Draggable, "Draggable")
-- Couples well with MoveOnDrag

function Draggable:awake()
    self.dragging = false
end

function Draggable:onMouseMove(x, y, dx, dy)
    self.hover = false

    if self.actor.BoundingBox:getRect():isVectorWithin(x,y) then
        self.hover = true
    end

    if self.dragging then
        self.actor:callForAllComponents("Draggable_onDrag",x,y,dx,dy)
    end
end

function Draggable:onMousePress(x, y, button, wasRelease, isClickConsumed)
    if not isClickConsumed then
        if button == 1 and not wasRelease then
            if self.hover then
                self.actor:callForAllComponents("Draggable_onDragStart",x,y,dx,dy)
                self.dragging = true
            end
        end

        if button == 1 and wasRelease and self.dragging then
            self.actor:callForAllComponents("Draggable_onDragEnd",x,y,dx,dy)
            self.dragging = false
        end
    end

    if self.dragging then
        self.actor:scene():consumeClick()
    end
end

return Draggable
