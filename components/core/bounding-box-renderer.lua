local BoundingBoxRenderer = {}

registerComponent(BoundingBoxRenderer, "BoundingBoxRenderer", {"BoundingBox"})

function BoundingBoxRenderer:draw(x, y)
    local w, h = self.actor.BoundingBox:getRect():wh()
    local r, g, b = 1, 1, 1
    if w < 0 then
        r = 0
    end

    if h < 0 then
        b = 0
    end

    love.graphics.setColor(r, g, b, 1)
    love.graphics.rectangle("line", self.actor.BoundingBox:getRect():xywh())
end

return BoundingBoxRenderer
