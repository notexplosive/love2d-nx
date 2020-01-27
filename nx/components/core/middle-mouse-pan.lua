local MiddleMousePan = {}

registerComponent(MiddleMousePan, "MiddleMousePan")

function MiddleMousePan:awake()
    self.dragging = false
end

function MiddleMousePan:onMousePress(x, y, button, wasRelease, isClickConsumed)
    if button == 3 and not isClickConsumed then
        self.dragging = not wasRelease
        self.actor:scene():consumeClick()
    end
end

function MiddleMousePan:onMouseMove(x, y, dx, dy)
    if self.dragging then
        local dragVec = Vector.new(dx, dy)
        self.actor:scene():getViewport().actor:move(-dragVec)
    end
end

return MiddleMousePan
