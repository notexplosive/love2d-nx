local Sprite = require("nx/game/assets/sprite")
local SpriteRenderer = {}

registerComponent(SpriteRenderer, "SpriteRenderer")

function SpriteRenderer.create_object()
    return newObject(SpriteRenderer)
end

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
end

function SpriteRenderer:awake()
    self.currentAnimation = nil
    self.isLooping = true
    self.currentFrame = 0
    self.fps = 10
    self.scale = 1
    self.scaleX = 1
    self.scaleY = 1
    self.flipX = false
    self.flipY = false
    self.color = {1, 1, 1, 1}
    self.offset = Vector.new()

    self.onAnimationEnd = function()
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
                math.floor(self.currentFrame),
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

        love.graphics.circle('fill',x,y,5)
    end
end

function SpriteRenderer:update(dt)
    if self.currentAnimation then
        self.currentFrame = self.currentFrame + dt * self.fps
        if self.currentFrame > self.currentAnimation.last + 1 then
            self.onAnimationEnd()
            if self.isLooping then
                self.currentFrame = self.currentAnimation.first
            else
                self.currentFrame = self.currentAnimation.last
                self.onAnimationEnd = function()
                end
            end
        end

        if self.currentAnimation.last == self.currentAnimation.first then
            self.currentFrame = self.currentAnimation.first
        end
    end
end

-- Accessors and Mutators
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
    self.currentFrame = self.currentAnimation.first
    return self
end

function SpriteRenderer:setFrame(index)
    self.currentFrame = self.currentAnimation.first + index - 2
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
