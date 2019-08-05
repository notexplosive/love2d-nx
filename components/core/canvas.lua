local Canvas = {}

registerComponent(Canvas, "Canvas", {"BoundingBox"})

function Canvas:setup(offsetX,offsetY,growByW,growByH)
    self.offset = Vector.new(offsetX,offsetY)
    self.growBy = Size.new(growByW,growByH)
    self:setDimensions(self.actor.BoundingBox:getDimensions())
end

function Canvas:awake()
    self.drawList = {}
    self.offset = Vector.new(0,0)
    self.growBy = Size.new(0,0)
    self:setDimensions(self.actor.BoundingBox:getDimensions())
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
    love.graphics.draw(self.canvas, x + self.offset.x, y + self.offset.y)
end

function Canvas:setDimensions(w, h)
    self.canvas = love.graphics.newCanvas(w + self.growBy.width, h + self.growBy.height)
end

function Canvas:BoundingBoxEditor_onResizeEnd(rect)
    self:setDimensions(rect:dimensions())
end

function Canvas:canvasDraw(fn)
    append(self.drawList, fn)
end

return Canvas
