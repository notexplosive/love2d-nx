local SetPosToCursor = {}

registerComponent(SetPosToCursor, "SetPosToCursor")

function SetPosToCursor:awake()
    self.cursorPos = Vector.new()
end

function SetPosToCursor:update(dt)
    self.actor:setPos(self.cursorPos)
end

function SetPosToCursor:onMouseMove(x, y)
    self.cursorPos = Vector.new(x, y)
end

function SetPosToCursor:onMousePress(x, y, button)
    self.cursorPos = Vector.new(x, y)
end

return SetPosToCursor
