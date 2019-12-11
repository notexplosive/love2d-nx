local RotateWithWorldDrag = {}

registerComponent(RotateWithWorldDrag, "RotateWithWorldDrag")

function RotateWithWorldDrag:setup(offset)
    self.offset = offset
end

function RotateWithWorldDrag:reverseSetup()
    return self.offset
end

function RotateWithWorldDrag:awake()
    self.offset = 0
end

function RotateWithWorldDrag:draw(x, y)
    self.actor:setAngle(self.actor.WorldDragListener:getAngle() + self.offset)
end

function RotateWithWorldDrag:update(dt)
end

return RotateWithWorldDrag
