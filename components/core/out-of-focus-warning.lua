local OutOfFocusWarning = {}

registerComponent(OutOfFocusWarning, "OutOfFocusWarning")

function OutOfFocusWarning:awake()
end

function OutOfFocusWarning:draw(x, y)
    if not self.focus then
    love.graphics.setColor(0, 0, 0.25, 0.25)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getDimensions())
    end
end

function OutOfFocusWarning:update(dt)
end

function OutOfFocusWarning:onMouseFocus(focus)
    self.focus = focus
end

return OutOfFocusWarning
