local NinePatch = {}

registerComponent(NinePatch, "NinePatch", {"BoundingBox"})

function NinePatch:setup(spriteName, inflateWidth, inflateHeight, offsetX, offsetY)
    self.sprite = Assets.images[spriteName]
    self.inflateSize = Size.new(inflateWidth or 0, inflateHeight or 0)
    self.offsetVector = Vector.new(offsetX or 0, offsetY or 0)

    -- TODO: support center
    self.noCenter = true

    self.cachedQuad = love.graphics.newQuad(0, 0, 0, 0, self.sprite.image:getDimensions())
end

function NinePatch:start()
    assert(self.sprite, "setup not run")
end

function NinePatch:draw()
    local rect = self:getRect()
    local x, y, width, height = rect:xywh()

    local topLeftQuad = self.sprite:getQuadAt(1)
    local topRightQuad = self.sprite:getQuadAt(3)
    local bottomLeftQuad = self.sprite:getQuadAt(7)
    local bottomRightQuad = self.sprite:getQuadAt(9)
    local middleQuad = self.sprite:getQuadAt(5)

    local _, _, quadWidth, quadHeight = topLeftQuad:getViewport()
    local right = x + width - quadWidth
    local left = x
    local top = y
    local bottom = y + height - quadHeight
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(self.sprite.image, topLeftQuad, left, top)
    love.graphics.draw(self.sprite.image, topRightQuad, right, top)
    love.graphics.draw(self.sprite.image, bottomRightQuad, right, bottom)
    love.graphics.draw(self.sprite.image, bottomLeftQuad, left, bottom)

    local topMiddleQuad = self.sprite:getQuadAt(2)
    local leftMiddleQuad = self.sprite:getQuadAt(4)
    local rightMiddleQuad = self.sprite:getQuadAt(6)
    local bottomMiddleQuad = self.sprite:getQuadAt(8)

    self:fillHorizontal(topMiddleQuad, left, top)
    self:fillHorizontal(bottomMiddleQuad, left, bottom)
    self:fillVertical(leftMiddleQuad, left, top)
    self:fillVertical(rightMiddleQuad, right, top)
    self:fillHorizontalRemainder(topMiddleQuad, left, top)
    self:fillHorizontalRemainder(bottomMiddleQuad, left, bottom)
    self:fillVerticalRemainder(leftMiddleQuad, left, top)
    self:fillVerticalRemainder(rightMiddleQuad, right, top)
    self:fillMiddleRemainder(middleQuad, left, top)
    self:fillMiddle(middleQuad, left, top)

    for i = 1, (bottom - top) / quadHeight - 1 do
        self:fillHorizontalRemainder(middleQuad, left, top + quadHeight * i)
    end

    for i = 1, (right - left) / quadWidth - 1 do
        self:fillVerticalRemainder(middleQuad, left + quadWidth * i, top)
    end
end

function NinePatch:getRect()
    local rect = self.actor.BoundingBox:getRect()
    rect:inflate(self.inflateSize:wh())
    rect:move(self.offsetVector)
    return rect
end

function NinePatch:getQuadDimensions()
    local _, _, quadWidth, quadHeight = self.sprite:getQuadAt(1):getViewport()
    return quadWidth, quadHeight
end

function NinePatch:getSides()
    local quadWidth, quadHeight = self:getQuadDimensions()
    local x, y, width, height = self:getRect():xywh()
    local top = y
    local bottom = y + height - quadHeight
    local left = x
    local right = x + width - quadWidth

    return top, bottom, left, right
end

function NinePatch:getWidthRemainder()
    local quadWidth, quadHeight = self:getQuadDimensions()
    return self:getRect():width() % quadWidth
end

function NinePatch:getHeightRemainder()
    local quadWidth, quadHeight = self:getQuadDimensions()
    return self:getRect():height() % quadHeight
end

function NinePatch:getWidthUpUntilYouNeedTheRemainder()
    local quadWidth, quadHeight = self:getQuadDimensions()
    return math.floor(self:getRect():width() / quadWidth) * quadWidth - quadWidth * 2
end

function NinePatch:getHeightUpUntilYouNeedTheRemainder()
    local quadWidth, quadHeight = self:getQuadDimensions()
    return math.floor(self:getRect():height() / quadHeight) * quadHeight - quadHeight * 2
end

function NinePatch:getThisQuadWithTheseDimensions(oldQuad, width, height)
    local oldQuadRect = Rect.new(oldQuad:getViewport())
    self.cachedQuad:setViewport(oldQuadRect:x(), oldQuadRect:y(), width, height)
    return self.cachedQuad
end

function NinePatch:fillHorizontal(quad, left, y)
    local quadWidth, quadHeight = self:getQuadDimensions()
    for dx = quadWidth, self:getRect():width() - quadWidth * 2, quadWidth do
        love.graphics.draw(self.sprite.image, quad, left + dx, y)
    end
end

function NinePatch:fillVertical(quad, x, top)
    local quadWidth, quadHeight = self:getQuadDimensions()
    for dy = quadHeight, self:getRect():height() - quadHeight * 2, quadHeight do
        love.graphics.draw(self.sprite.image, quad, x, top + dy)
    end
end

function NinePatch:fillHorizontalRemainder(quad, left, y)
    local quadWidth, quadHeight = self:getQuadDimensions()
    local x = left + self:getWidthUpUntilYouNeedTheRemainder() + quadWidth

    local remainderQuad = self:getThisQuadWithTheseDimensions(quad, self:getWidthRemainder(), quadHeight)
    love.graphics.draw(self.sprite.image, remainderQuad, x, y)
end

function NinePatch:fillVerticalRemainder(quad, x, top)
    local quadWidth, quadHeight = self:getQuadDimensions()
    local y = top + self:getHeightUpUntilYouNeedTheRemainder() + quadHeight

    local remainderQuad = self:getThisQuadWithTheseDimensions(quad, quadWidth, self:getHeightRemainder())
    love.graphics.draw(self.sprite.image, remainderQuad, x, y)
end

function NinePatch:fillMiddleRemainder(quad, left, top)
    local quadWidth, quadHeight = self:getQuadDimensions()
    local x = left + self:getWidthUpUntilYouNeedTheRemainder() + quadWidth
    local y = top + self:getHeightUpUntilYouNeedTheRemainder() + quadHeight

    local remainderQuad = self:getThisQuadWithTheseDimensions(quad, self:getWidthRemainder(), self:getHeightRemainder())
    love.graphics.draw(self.sprite.image, remainderQuad, x, y)
end

function NinePatch:fillMiddle(quad, left, top)
    local quadWidth, quadHeight = self:getQuadDimensions()
    for dx = quadWidth, self:getRect():width() - quadWidth * 2, quadWidth do
        for dy = quadHeight, self:getRect():height() - quadHeight * 2, quadHeight do
            love.graphics.draw(self.sprite.image, quad, left + dx, top + dy)
        end
    end
end

return NinePatch
