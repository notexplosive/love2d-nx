local Draggable = {}

registerComponent(Draggable, "Draggable", {"Clickable"})

function Draggable:setup(button, friction)
    self.button = button
    self.friction = friction
end

function Draggable:reverseSetup()
    return self.button, self.friction
end

function Draggable:awake()
    self.button = 1
    self.startDragPoint = nil
    self.dragging = false
    self.friction = 4
end

function Draggable:onMouseMove(x, y, dx, dy)
    local newPos = self:getDraggedPos(x, y)

    if newPos then
        if not self.dragging and (newPos - self.startDragPoint + self.offset):length() >= self.friction then
            self.actor:callForAllComponents("Draggable_onDragStart", self.startDragPoint:xy())
            self.dragging = true
        end

        if self.dragging then
            local d = newPos - self.startDragPoint
            self.actor:scene():consumeHover()
            self.actor:callForAllComponents("Draggable_onDrag", x, y, newPos.x, newPos.y, d.x, d.y)
        end
    end
end

function Draggable:getDraggedPos(currentX, currentY)
    if self.startDragPoint then
        return Vector.new(currentX, currentY) - self.offset - self.actor:scene().camera
    end

    return nil
end

function Draggable:Clickable_onClickStart(button, x, y)
    if button == self.button then
        self.startDragPoint = Vector.new(x, y)
        self.offset = self.startDragPoint - self.actor:pos()
    end
end

function Draggable:onMousePress(x, y, button, wasRelease)
    if wasRelease and button == self.button then
        if self.dragging then
            self.actor:callForAllComponents("Draggable_onDragEnd", x, y)
        end

        self.dragging = false
        self.startDragPoint = nil
        self.offset = nil
    end
end

return Draggable
