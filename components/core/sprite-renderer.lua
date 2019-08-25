local Sprite = require("nx/game/assets/sprite")
local SpriteRenderer = {}

registerComponent(SpriteRenderer, "SpriteRenderer")

function SpriteRenderer:setup(spriteName, anim, scale, color, offx, offy)
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
        local x,y,w,h = self:getBoundingBox():xywh()
        self.actor.BoundingBox:setup(w,h,self.sprite.gridWidth*self:getScaleX()/2,self.sprite.gridHeight*self:getScaleY()/2)
    end
end

function SpriteRenderer:awake()
    self.actor:addComponentSafe(Components.PlayHead)
    self.actor:addComponentSafe(Components.AnimationFrameTracker)

    self.currentAnimation = nil

    self.scale = 1
    self.scaleX = 1
    self.scaleY = 1
    self.flipX = false
    self.flipY = false
    self.color = {1, 1, 1, 1}
    self.offset = Vector.new()
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

        local frameNumber = math.floor(self.actor.AnimationFrameTracker:get())
        if self.actor.visible then
            self.sprite:draw(
                frameNumber,
                x,
                y,
                math.floor(self.sprite.gridWidth / 2) + self.offset.x,
                math.floor(self.sprite.gridHeight / 2) + self.offset.y,
                self.actor:angle(),
                self.scale * xFactor * self.scaleX,
                self.scale * yFactor * self.scaleY,
                self.color
            )
        end
    end
end

function SpriteRenderer:setSprite(sprite)
    assert(sprite, "SpriteRenderer:setSprite was passed a nil")
    assert(sprite:type() == Sprite)

    if self.sprite == sprite then
        return
    end

    self.sprite = sprite
    self.currentAnimation = nil
    return self
end

function SpriteRenderer:setAnimation(animName)
    assert(self.sprite)
    assert(self.sprite.animations[animName], "No animation called " .. animName)

    if self.currentAnimation == self.sprite.animations[animName] then
        return
    end

    self.currentAnimation = self.sprite.animations[animName]

    self.actor.AnimationFrameTracker:setRange(self.currentAnimation.first, self.currentAnimation.last)
    return self
end

function SpriteRenderer:setFrame(index)
    self.actor.AnimationFrameTracker:set(index)
end

function SpriteRenderer:getAnimation()
    if self.currentAnimation == nil then
        return "nil"
    end

    return self.currentAnimation.name
end

function SpriteRenderer:setFlipX(b)
    self.flipX = b
end

function SpriteRenderer:setFlipY(b)
    self.flipY = b
end

function SpriteRenderer:getScaleX()
    return self.scale * self.scaleX
end

function SpriteRenderer:getScaleY()
    return self.scale * self.scaleY
end

function SpriteRenderer:pause()
    self.actor.PlayHead:pause()
end

function SpriteRenderer:getBoundingBox()
    local _, _, width, height = self.sprite:getQuadAt(1):getViewport()
    local w = self.scale * self.scaleX * width
    local h = self.scale * self.scaleY * height
    local camera = self.actor:scene().camera
    local x = self.actor:pos().x - w / 2 - camera.x
    local y = self.actor:pos().y - h / 2 - camera.y
    return Rect.new(x, y, w, h)
end

function SpriteRenderer:hasAnimation(animName)
    return self.sprite and self.sprite.animations[animName]
end

return SpriteRenderer
