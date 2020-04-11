local Canvas = {}

registerComponent(Canvas, "Canvas", {"BoundingBox"})

function Canvas:setup(offsetX, offsetY, growByW, growByH)
    self.offset = Vector.new(offsetX, offsetY)
    self.growBy = Size.new(growByW, growByH)
    self:setDimensions(self.actor.BoundingBox:getDimensions())
end

function Canvas:awake()
    self.drawList = {}
    self.offset = Vector.new(0, 0)
    self.growBy = Size.new(0, 0)
    self:setDimensions(self.actor.BoundingBox:getDimensions())
end

function Canvas:draw(x, y)
    self:drawAndClear(x, y)
end

function Canvas:drawAndClear(x, y)
    self:drawWithoutClear(x, y)
    self.drawList = {}
end

function Canvas:drawWithoutClear(x, y)
    local canvas = love.graphics.getCanvas()
    love.graphics.setCanvas(self.canvas)
    for i, fn in ipairs(self.drawList) do
        fn(self.actor.BoundingBox:getDimensions())
    end
    love.graphics.setCanvas(canvas)

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(self.canvas, math.floor(x + self.offset.x), math.floor(y + self.offset.y))
end

function Canvas:setDimensions(w, h)
    self.canvas = love.graphics.newCanvas(w + self.growBy.width, h + self.growBy.height)
end

function Canvas:getRect()
    local camera = self.actor:scene():getViewportPosition()
    local width, height = self:getDimensions()
    return Rect.new(
        self.actor:pos().x + self.offset.x - camera.x,
        self.actor:pos().y + self.offset.y - camera.y,
        width,
        height
    )
end

function Canvas:getDimensions()
    return self.canvas:getDimensions()
end

function Canvas:BoundingBoxEditor_onResizeEnd(rect)
    self:setDimensions(rect:dimensions())
end

function Canvas:BoundingBoxEditor_onResizeDrag(rect)
    self:setDimensions(rect:dimensions())
end

function Canvas:canvasDraw(fn)
    append(self.drawList, fn)
end

return Canvas
