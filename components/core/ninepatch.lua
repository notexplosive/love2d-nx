local NinePatch = {}

registerComponent(NinePatch, "NinePatch", {"BoundingBox"})

function NinePatch:setup(spriteName, inflateWidth, inflateHeight)
    self.sprite = Assets.images[spriteName]
    self.inflateSize = Size.new(inflateWidth, inflateHeight)

    -- TODO: support center
    self.noCenter = true

    self.remainderQuad = love.graphics.newQuad(0, 0, 0, 0, self.sprite.image:getDimensions())
end

function NinePatch:start()
    assert(self.sprite, "setup not run")
end

function NinePatch:draw()
    local rect = self:getRect()

    love.graphics.setColor(1, 1, 0, 0.5)
    love.graphics.rectangle("fill", rect:xywh())
    local x, y, width, height = rect:xywh()

    local topLeftQuad = self.sprite:getQuadAt(1)
    local topMiddleQuad = self.sprite:getQuadAt(2)
    local topRightQuad = self.sprite:getQuadAt(3)
    local leftMiddleQuad = self.sprite:getQuadAt(7)
    local rightMiddleQuad = self.sprite:getQuadAt(9)
    local bottomLeftQuad = self.sprite:getQuadAt(13)
    local bottomMiddleQuad = self.sprite:getQuadAt(14)
    local bottomRightQuad = self.sprite:getQuadAt(15)

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

    local ooo = 0
    for mmm = quadWidth, rect:width() - quadWidth * 2, quadWidth do
        love.graphics.draw(self.sprite.image, topMiddleQuad, left + mmm, top)
        ooo = mmm
    end

    for mmm = quadWidth, rect:width() - quadWidth * 2, quadWidth do
        love.graphics.draw(self.sprite.image, bottomMiddleQuad, left + mmm, bottom)
    end

    self:bibble(rect, topMiddleQuad, ooo)

    local eee = 0
    for mmm = quadHeight, rect:height() - quadHeight * 2, quadHeight do
        love.graphics.draw(self.sprite.image, leftMiddleQuad, left, top + mmm)
        eee = mmm
    end

    for mmm = quadHeight, rect:height() - quadHeight * 2, quadHeight do
        love.graphics.draw(self.sprite.image, rightMiddleQuad, right, top + mmm)
    end

    self:bobble(rect, leftMiddleQuad, eee)
end

function NinePatch:getRect()
    local rect = self.actor.BoundingBox:getRect()
    rect:inflate(self.inflateSize:wh())
    return rect
end

function NinePatch:getQuadDimensions()
    local _, _, quadWidth, quadHeight = self.sprite:getQuadAt(1):getViewport()
    return quadWidth,quadHeight
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

function NinePatch:bibble(rect, quad, ooo, quadWidth, quadHeight)
    local quadWidth, quadHeight = self:getQuadDimensions()
    local x, y, width, height = rect:xywh()
    local top, bottom, left, right = self:getSides()

    local quadRect = Rect.new(quad:getViewport())
    local remainder = rect:width() % quadWidth
    local xPositionOfBibble = left + ooo + quadWidth

    self.remainderQuad:setViewport(quadRect:x(), quadRect:y(), remainder, quadHeight)
    love.graphics.draw(self.sprite.image, self.remainderQuad, xPositionOfBibble, top)

    quadRect:move(0, quadHeight * 2)
    self.remainderQuad:setViewport(quadRect:x(), quadRect:y(), remainder, quadHeight)
    love.graphics.draw(self.sprite.image, self.remainderQuad, xPositionOfBibble, bottom)
end

function NinePatch:bobble(rect, quad, ooo, quadWidth, quadHeight)
    local _, _, quadWidth, quadHeight = self.sprite:getQuadAt(1):getViewport()
    local x, y, width, height = rect:xywh()
    local top, bottom, left, right = self:getSides()

    local quadRect = Rect.new(quad:getViewport())
    local remainder = rect:height() % quadHeight
    local yPositionOfBobble = top + ooo + quadHeight

    self.remainderQuad:setViewport(quadRect:x(), quadRect:y(), quadWidth, remainder)
    love.graphics.draw(self.sprite.image, self.remainderQuad, left, yPositionOfBobble)

    quadRect:move(quadWidth * 2, 0)
    self.remainderQuad:setViewport(quadRect:x(), quadRect:y(), quadWidth, remainder)
    love.graphics.draw(self.sprite.image, self.remainderQuad, right, yPositionOfBobble)
end

return NinePatch
