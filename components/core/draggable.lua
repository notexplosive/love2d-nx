local Draggable = {}

registerComponent(Draggable, "Draggable", {"Clickable"})

function Draggable:setup(button)
    self.button = button
end

function Draggable:awake()
    self.button = 1
    self.startDragPoint = nil
end

function Draggable:onMouseMove(x, y, dx, dy)
    if self.dragging and Vector.new(dx, dy):length() > 0 then
        self.actor:callForAllComponents("Draggable_onDrag", x, y, (Vector.new(x, y) - self.startDragPoint):xy())
    end
end

function Draggable:Clickable_onClickStart(button, x, y)
    if button == self.button then
        self.dragging = true
        self.startDragPoint = Vector.new(x, y) - self.actor:pos()
        self.actor:callForAllComponents("Draggable_onDragStart", self.actor:pos():xy())
    end
end

function Draggable:onMousePress(x, y, button, wasRelease)
    if wasRelease and button == self.button and self.dragging then
        self.dragging = false
        self.startDragPoint = nil
        self.actor:callForAllComponents("Draggable_onDragEnd", x, y)
    end
end

return Draggable
