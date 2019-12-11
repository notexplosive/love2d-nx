local CenterPointRenderer = {}

registerComponent(CenterPointRenderer, "CenterPointRenderer", {"BoundingBox"})

function CenterPointRenderer:draw(x, y)
    local drawPos = Vector.new(x, y) + Vector.new(self.actor.BoundingBox:getRect():wh()) / 2
    local x, y = drawPos:xy()
    love.graphics.setColor(0.5, 0, 1, 1)
    love.graphics.circle("line", x, y, 3)
    love.graphics.circle("line", x, y, 10)
end

return CenterPointRenderer
