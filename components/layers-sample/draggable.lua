local Draggable = {}

registerComponent(Draggable, "Draggable")

function Draggable:awake()
    self.dragging = false
end

function Draggable:draw(x, y, inFocus)
    if self.hover or self.dragging then
        
    end
end

function Draggable:update(dt, inFocus)
end

function Draggable:onMouseMove(x, y, dx, dy)
    self.hover = false

    if isWithinBox(x, y, self.actor.BoundingBox:getRect()) then
        if not self.actor.Layer then
            self.hover = true
        else
            for i, actor in ipairs(self.actor.Layer:getAllActorsInOrder()) do
                if actor.Draggable.hover then
                    break
                else
                    if actor == self.actor then
                        self.hover = true
                    end
                end
            end
        end
    end

    if self.dragging then
        self.actor:move(Vector.new(dx,dy))
    end
end

function Draggable:onMousePress(x, y, button, wasRelease)
    if button == 1 and not wasRelease then
        if self.hover and self.actor.Layer then
            self.dragging = true
            self.actor.Layer:bringToFront()
        end
    end

    if button == 1 and wasRelease and self.dragging then
        self.dragging = false
    end
end

return Draggable
