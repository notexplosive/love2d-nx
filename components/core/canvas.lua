local Canvas = {}

registerComponent(Canvas, "Canvas", {"BoundingBox"})

function Canvas:awake()
    self:reset()
end

function Canvas:draw(x, y)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(self.canvas, x, y)
end

function Canvas:reset()
    self.canvas = love.graphics.newCanvas(self.actor.BoundingBox:getDimensions())
end

function Canvas:BoundingBoxEditor_onResize()
    self:reset()
end

return Canvas
