local Sprite = require("nx/game/assets/sprite")
local SpriteRenderer = {}

registerComponent(SpriteRenderer, "SpriteRenderer")

function SpriteRenderer:setup(spriteName, anim, scale, color, offx, offy)
    self:setSprite(spriteName)

    if anim then
        self:setAnimation(anim)
    end

    self.offset = Vector.new()
    if offx and offy then
        self.offset = Vector.new(offx, offy)
    end

    self.scale = scale or self.scale
    self.color = color or self.color

    if self.actor.BoundingBox then
        self:setupBoundingBox()
    end
end

function SpriteRenderer:reverseSetup()
    return self.spriteName, self:getAnimation(), self.scale, self.color, self.offset.x, self.offset.y
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

function SpriteRenderer:setSprite(spriteName)
    assert(spriteName, "Sprite name cannot be nil")
    assert(Assets.images[spriteName], "No sprite named " .. spriteName)

    local sprite = Assets.images[spriteName]
    assert(sprite, "SpriteRenderer:setSprite was passed a nil")
    assert(sprite:type() == Sprite)

    if self.sprite == sprite then
        return
    end

    self.spriteName = spriteName
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
        return nil
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

function SpriteRenderer:setScale(s)
    self.scale = s
end

function SpriteRenderer:setColor(r, g, b, a)
    local color = {r, g, b, a}
    assert(#color == 3 or #color == 4, "Color is a list of 3 or 4 values")
    self.color = color
end

function SpriteRenderer:setOffset(dx, dy)
    self.offset = Vector.new(dx, dy)
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

function SpriteRenderer:setupBoundingBox()
    local x, y, w, h = self:getBoundingBox():xywh()
    self.actor.BoundingBox:setup(
        w,
        h,
        self.sprite.gridWidth * self:getScaleX() / 2,
        self.sprite.gridHeight * self:getScaleY() / 2
    )
end

function SpriteRenderer:hasAnimation(animName)
    return self.sprite and self.sprite.animations[animName]
end

local Test = require("nx/test")
Test.registerComponentTest(
    SpriteRenderer,
    function()
        local Actor = require("nx/game/actor")
        local setupInput = {"linkin", "walk", 5, {1, 0, 1}, 10, -20}
        local sp = Actor.new("TestActor"):addComponent(Components.SpriteRenderer, unpack(setupInput))

        -- Reverse Setup
        Test.assert(setupInput, {sp:reverseSetup()}, "ReverseSetup reflects setup")

        -- Setters followed by reverseSetup
        sp:setSprite("numbers")
        sp:setAnimation("all")
        sp:setScale(3)
        sp:setColor(1, 1, 0)
        sp:setOffset(40, -20)
        local newReverseSetupOutput = {sp:reverseSetup()}
        Test.assert("numbers", newReverseSetupOutput[1], "ReverseSetup gets SpriteName")
        Test.assert("all", newReverseSetupOutput[2], "ReverseSetup gets Animation")
        Test.assert(3, newReverseSetupOutput[3], "ReverseSetup gets Scale")
        Test.assert({1, 1, 0}, newReverseSetupOutput[4], "ReverseSetup gets Color")
        Test.assert(40, newReverseSetupOutput[5], "ReverseSetup gets OffX")
        Test.assert(-20, newReverseSetupOutput[6], "ReverseSetup gets OffY")
    end
)

return SpriteRenderer
