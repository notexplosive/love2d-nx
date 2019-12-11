local BoundingBoxOutlineRenderer = {}

registerComponent(BoundingBoxOutlineRenderer, "BoundingBoxOutlineRenderer")

function BoundingBoxOutlineRenderer:draw(x, y)
    x = x - self.actor.BoundingBox.offset.x
    y = y - self.actor.BoundingBox.offset.y
    love.graphics.setColor(0, 0, 0)
    local w, h = self.actor.BoundingBox:getRect():wh()
    love.graphics.rectangle("line", math.floor(x), math.floor(y), math.floor(w), math.floor(h))
end

return BoundingBoxOutlineRenderer
