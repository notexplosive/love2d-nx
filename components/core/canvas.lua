local Canvas = {}

registerComponent(Canvas, "Canvas", {"BoundingBox"})

function Canvas:awake()
    self.drawList = {}
    self:reset()
end

function Canvas:draw(x, y)
    local canvas = love.graphics.getCanvas()
    love.graphics.setCanvas(self.canvas)
    for i,fn in ipairs(self.drawList) do
        fn(self.actor.BoundingBox:getDimensions())
    end
    self.drawList = {}
    love.graphics.setCanvas(canvas)

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(self.canvas, x, y)
end

function Canvas:reset()
    self.canvas = love.graphics.newCanvas(self.actor.BoundingBox:getDimensions())
end

function Canvas:setDimensions(w, h)
    self.canvas = love.graphics.newCanvas(w, h)
end

function Canvas:BoundingBoxEditor_onResizeEnd(rect)
    self:setDimensions(rect:dimensions())
end

function Canvas:canvasDraw(fn)
    append(self.drawList, fn)
end

return Canvas
