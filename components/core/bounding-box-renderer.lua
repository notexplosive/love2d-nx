local BoundingBoxRenderer = {}

registerComponent(BoundingBoxRenderer, "BoundingBoxRenderer", {"BoundingBox"})

function BoundingBoxRenderer:draw(x, y)
    love.graphics.setColor(1,0,1,1)
    love.graphics.rectangle('line',self.actor.BoundingBox:getRect())
end

return BoundingBoxRenderer
