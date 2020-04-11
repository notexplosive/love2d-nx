local BoundingBoxRenderer = {}

registerComponent(BoundingBoxRenderer, "BoundingBoxRenderer", {"BoundingBox"})

function BoundingBoxRenderer:setup(color)
    self.backgroundColor = color
end

function BoundingBoxRenderer:draw(x, y)
    love.graphics.setColor(self.backgroundColor or {1, 0, 1})
    local x, y, w, h = self.actor.BoundingBox:getRect():xywh()
    love.graphics.rectangle("fill", math.floor(x), math.floor(y), math.floor(w), math.floor(h))
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("line", math.floor(x), math.floor(y), math.floor(w), math.floor(h))
end

return BoundingBoxRenderer
