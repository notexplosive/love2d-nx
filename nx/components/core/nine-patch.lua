local NinePatch = {}

registerComponent(NinePatch, "NinePatch", {"BoundingBox"})

function NinePatch:setup(spriteName, inflateWidth, inflateHeight, offsetX, offsetY)
    self.spriteName = spriteName
    self.sprite = Assets.images[spriteName]
    assert(self.sprite, "no sprite with name " .. spriteName)
    self.inflateSize = Size.new(inflateWidth or 0, inflateHeight or 0)
    self.offsetVector = Vector.new(offsetX or 0, offsetY or 0)

    local gw, gh = self.sprite:getGridCellDimensions()

    local top = 0
    local left = 0
    local right = gw * 2
    local bottom = gh * 2
    local middleX = gw
    local middleY = gh

    self.topBottomQuad = love.graphics.newQuad(0, 0, 0, 0, gw, gh)
    self.leftRightQuad = love.graphics.newQuad(0, 0, 0, 0, gw, gh)
    self.middleQuad = love.graphics.newQuad(0, 0, 0, 0, gw, gh)

    self.imageAndQuads = {
        top = {image = self:getCroppedImage(middleX, top), quad = self.topBottomQuad},
        bottom = {image = self:getCroppedImage(middleX, bottom), quad = self.topBottomQuad},
        left = {image = self:getCroppedImage(left, middleY), quad = self.leftRightQuad},
        right = {image = self:getCroppedImage(right, middleY), quad = self.leftRightQuad},
        middle = {image = self:getCroppedImage(middleX, middleY), quad = self.middleQuad},
        topLeft = {image = self:getCroppedImage(left, top)},
        topRight = {image = self:getCroppedImage(right, top)},
        bottomLeft = {image = self:getCroppedImage(left, bottom)},
        bottomRight = {image = self:getCroppedImage(right, bottom)}
    }
end

function NinePatch:reverseSetup()
    return self.spriteName, self.inflateSize.width, self.inflateSize.height, self.offsetVector.x, self.offsetVector.y
end

function NinePatch:start()
    assert(self.sprite, "setup not run")
end

function NinePatch:draw(x, y)
    local rect = self:getRect()
    local x, y, width, height = rect:xywh()

    local gw, gh = self.sprite:getGridCellDimensions()
    local middleWidth = width - gw * 2
    local middleHeight = height - gh * 2
    local rightX = x + width - gw
    local bottomY = y + height - gw
    local middleX = x + gw
    local middleY = y + gh

    self.topBottomQuad:setViewport(0, 0, middleWidth, gh)
    self.leftRightQuad:setViewport(0, 0, gw, middleHeight)
    self.middleQuad:setViewport(0, 0, middleWidth, middleHeight)

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(self.imageAndQuads.topLeft.image, x, y)
    love.graphics.draw(self.imageAndQuads.topRight.image, rightX, y)
    love.graphics.draw(self.imageAndQuads.bottomLeft.image, x, bottomY)
    love.graphics.draw(self.imageAndQuads.bottomRight.image, rightX, bottomY)

    love.graphics.draw(self.imageAndQuads.top.image, self.imageAndQuads.top.quad, middleX, y)
    love.graphics.draw(self.imageAndQuads.left.image, self.imageAndQuads.left.quad, x, middleY)
    love.graphics.draw(self.imageAndQuads.right.image, self.imageAndQuads.right.quad, rightX, middleY)
    love.graphics.draw(self.imageAndQuads.bottom.image, self.imageAndQuads.bottom.quad, middleX, bottomY)
    love.graphics.draw(self.imageAndQuads.middle.image, self.imageAndQuads.middle.quad, middleX, middleY)
end

function NinePatch:getCroppedImage(x, y)
    -- TODO: move this to Sprite so it can be cached there?
    -- if we have multiple Ninepatches with the same texture we shouldn't do this calculation twice
    local width, height = self.sprite.gridWidth, self.sprite.gridHeight
    local img = love.image.newImageData(self.sprite.filename)
    local cropped = love.image.newImageData(width, height)
    cropped:paste(img, 0, 0, x, y, width, height)
    local croppedImage = love.graphics.newImage(cropped)
    croppedImage:setWrap("repeat", "repeat")

    return croppedImage
end

function NinePatch:getCellDimensions()
    return self.sprite:getGridCellDimensions()
end

function NinePatch:getRect()
    local rect = self.actor.BoundingBox:getRect()
    rect:inflate(self.inflateSize:wh())
    rect:move(self.offsetVector)
    return rect
end

local Test = require("nx/test")
Test.registerComponentTest(
    NinePatch,
    function()
        local Actor = require("nx/game/actor")
        local actor = Actor.new()
        local setupArgs = {"windowchrome", 20, 30, 40, 50}
        actor:addComponent(Components.BoundingBox)
        local subject = actor:addComponent(NinePatch, unpack(setupArgs))
        Test.assert(setupArgs, {subject:reverseSetup()}, "reverseSetup can be fed to setup")
    end
)

return NinePatch
