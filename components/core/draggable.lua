local Draggable = {}

registerComponent(Draggable,'Draggable', {"Clickable"})

function Draggable:setup(button)
    self.button = button
end

function Draggable:awake()
    self.button = 1
end

function Draggable:onMouseMove(x,y,dx,dy)
    if self.dragging and Vector.new(dx,dy):length() > 0 then
        self.actor:callForAllComponents("Draggable_onDrag", x, y, dx, dy)
    end
end

function Draggable:Clickable_onClickStart(button)
    if button == self.button then
        self.dragging = true
        self.actor:callForAllComponents("Draggable_onDragStart", self.actor:pos():xy())
    end
end

function Draggable:onMousePress(x,y,button,wasRelease)
    if wasRelease and button == self.button and self.dragging then
        self.dragging = false
        self.actor:callForAllComponents("Draggable_onDragEnd", x, y)
    end

end

return Draggable