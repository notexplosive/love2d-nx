local Sprite = require("nx/game/sprite")
local SpriteRenderer = {}

registerComponent(SpriteRenderer, "SpriteRenderer")

function SpriteRenderer:setup(spriteName, anim, scale, color, offx, offy)
    self.playHead = self.actor:addComponentSafe(Components.PlayHead, 0)
    self.playHeadIncrements = self.actor:addComponentSafe(Components.PlayHeadDiscreteIncrements, 1)

    self.currentAnimation = nil

    self.scale = 1
    self.flipX = false
    self.flipY = false
    self.color = {1, 1, 1, 1}
    self.offset = Vector.new()
    self.fps = 10

    self:setRange(1, 1)

    assert(spriteName, "Sprite name cannot be nil")
    assert(Assets.images[spriteName], "No sprite named " .. spriteName)

    self:setSprite(Assets.images[spriteName])

    if anim then
        self:setAnimation(anim)
    end

    if offx and offy then
        self.offset = Vector.new(offx, offy)
    end

    self.scale = scale or self.scale
    self.color = color or self.color

    if self.actor.BoundingBox then
        local x, y, w, h = self:getSpriteBoundingBox():xywh()
        self.actor.BoundingBox:setup(
            w,
            h,
            self.sprite.gridWidth * self.scale / 2,
            self.sprite.gridHeight * self.scale / 2
        )
    end
end

function SpriteRenderer:draw(x, y)
    if self.sprite then
        local xFactor, yFactor = 1, 1
        if self.flipX then
            xFactor = -1
        end
        if self.flipY then
            yFactor = -1
        end

        if self.actor.visible then
            self.sprite:draw(
                self:getCurrentFrame(),
                x,
                y,
                math.floor(self.sprite.gridWidth / 2) + self.offset.x,
                math.floor(self.sprite.gridHeight / 2) + self.offset.y,
                self.actor:angle(),
                self.scale * xFactor,
                self.scale * yFactor,
                self.color
            )
        end
    end
end

function SpriteRenderer:getAnimation()
    if self.currentAnimation == nil then
        return "nil"
    end

    return self.currentAnimation.name
end

function SpriteRenderer:hasAnimation(animName)
    return self.sprite and self.sprite.animations[animName]
end

function SpriteRenderer:setAnimation(animName)
    assert(self.sprite)
    assert(self.sprite.animations[animName], "No animation called " .. animName)

    if self.currentAnimation == self.sprite.animations[animName] then
        return
    end

    self.currentAnimation = self.sprite.animations[animName]

    self:setRange(self.currentAnimation.first, self.currentAnimation.last)

    self.actor.PlayHead:set(0)
    self.actor.PlayHead:play()

    return self
end

function SpriteRenderer:setFps(fps)
    self.fps = fps
    self.playHead:setMaxTime(self.rangeSize / self.fps)
end

function SpriteRenderer:setSprite(sprite)
    assert(sprite, "SpriteRenderer:setSprite was passed a nil")
    assert(sprite:type() == Sprite, "Expected sprite, got " .. string.join(getKeys(sprite:type()), ",  "))

    if self.sprite == sprite then
        return
    end

    self.sprite = sprite
    self.currentAnimation = nil
    self:setRange(1, 1)
    return self
end

function SpriteRenderer:setFlipX(b)
    self.flipX = b
end

function SpriteRenderer:setFlipY(b)
    self.flipY = b
end

-- private

function SpriteRenderer:getCurrentFrame()
    return self.firstFrame + self.playHeadIncrements:getCurrentIncrement()
end

function SpriteRenderer:setRange(first, last)
    assert(first <= last, "Invalid range " .. first .. ", " .. last)
    self.firstFrame = first
    self.rangeSize = last - first
    self.playHeadIncrements:setNumberOfIncrements(self.rangeSize)
    self.playHead:setMaxTime(self.rangeSize / self.fps)
end

function SpriteRenderer:getSpriteBoundingBox()
    local _, _, width, height = self.sprite:getQuadAt(1):getViewport()
    local w = self.scale * width
    local h = self.scale * height
    local camera = self.actor:scene():getViewportPosition()
    local x = self.actor:pos().x - w / 2 - camera.x
    local y = self.actor:pos().y - h / 2 - camera.y
    return Rect.new(x, y, w, h)
end

-- Playhead forwarding functions
function SpriteRenderer:pause()
    self.actor.PlayHead:pause()
end

function SpriteRenderer:play()
    self.actor.PlayHead:play()
end

function SpriteRenderer:setLoop(b)
    self.actor.PlayHead:setLoop(b)
end

function SpriteRenderer:isPlaying()
    return self.actor.PlayHead:playing()
end

return SpriteRenderer
