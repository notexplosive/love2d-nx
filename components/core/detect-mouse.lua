local DetectMouse = {}

registerComponent(DetectMouse, "DetectMouse")

function DetectMouse:awake()
    self.buttons = {}
end

function DetectMouse:onMousePress(x, y, button, wasReleased)
    self.buttons[button] = not wasReleased
    self.pos = Vector.new(x, y)
end

function DetectMouse:onMouseMove(x, y, dx, dy)
    self.pos = Vector.new(x, y)
end

function DetectMouse:isButtonDown(button)
    return self.buttons[button] == true
end

function DetectMouse:getPos()
    return self.pos
end

return DetectMouse
