local BoundingBoxRenderer = {}

registerComponent(BoundingBoxRenderer, "BoundingBoxRenderer", {"BoundingBox"})

function BoundingBoxRenderer:setup(color)
    self.backgroundColor = color
end

function BoundingBoxRenderer:draw(x, y)
    x = x - self.actor.BoundingBox.offset.x
    y = y - self.actor.BoundingBox.offset.y
    love.graphics.setColor(self.backgroundColor or {1, 0, 1})
    local w, h = self.actor.BoundingBox:getDrawableRect():wh()
    love.graphics.rectangle("fill", math.floor(x), math.floor(y), math.floor(w), math.floor(h))
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("line", math.floor(x), math.floor(y), math.floor(w), math.floor(h))
end

return BoundingBoxRenderer
