local Sprite = require('nx/game/assets/sprite')
local SpriteRenderer = {}

registerComponent(SpriteRenderer,'SpriteRenderer')

function SpriteRenderer.create()
    return newObject(SpriteRenderer)
end

function SpriteRenderer:setup(spriteName,anim,scale,color)
    assert(spriteName,"Sprite name cannot be nil")
    assert(Assets[spriteName],"No sprite named " .. spriteName)

    self:setSprite(Assets[spriteName])
    
    if anim then
        self:setAnimation(anim)
    end

    if scale then
        self.scale = scale
    end

    if color then
        self.color = color
    end
end

function SpriteRenderer:awake()
    self.currentAnimation = nil
    self.isLooping = true
    self.currentFrame = 0
    self.fps = 10
    self.scale = 1
    self.scaleX = 1
    self.scaleY = 1
    self.angle = 0
    self.flipX = false
    self.flipY = false
    self.color = {1,1,1,1}

    self.onAnimationEnd = function()
    end
end

function SpriteRenderer:draw(x,y)
    if self.sprite then
        local quad = self.sprite.quads[math.floor(self.currentFrame)]
        if self.currentAnimation then
            quad = self.sprite.quads[math.floor(self.currentFrame)]
        end

        if quad == nil then
            quad = love.graphics.newQuad(0, 0, self.sprite.gridWidth, self.sprite.gridWidth, self.sprite.image:getDimensions())
        end

        local xFactor,yFactor = 1,1
        if self.flipX then
            xFactor = -1
        end
        if self.flipY then
            yFactor = -1
        end

        love.graphics.setColor(self.color)

        if self.actor.visible then
            love.graphics.draw(self.sprite.image,
                quad,
                math.floor(x),
                math.floor(y),
                self.angle,
                self.scale*xFactor*self.scaleX,
                self.scale*yFactor*self.scaleY,
                math.floor(self.sprite.gridWidth/2),
                math.floor(self.sprite.gridHeight/2))
        end
            
    end
end

function SpriteRenderer:update(dt)
    if self.currentAnimation then
        self.currentFrame = self.currentFrame + dt * self.fps
        if self.currentFrame > self.currentAnimation.last+1 then
            self.onAnimationEnd()
            if self.isLooping then
                self.currentFrame = self.currentAnimation.first
            else
                self.currentFrame = self.currentAnimation.last
                self.onAnimationEnd = function() end
            end
        end

        if self.currentAnimation.last == self.currentAnimation.first then
            self.currentFrame = self.currentAnimation.first
        end
    end
end

-- Accessors and Mutators
function SpriteRenderer:setSprite(sprite)
    assert(sprite,"SpriteRenderer:setSprite was passed a nil")
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
    assert(self.sprite.animations[animName],'No animation called ' .. animName)

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
        return 'nil'
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
    local quadCount = #self.sprite.quads
    -- Assumes sprites are always in one single horizontal strip, which is only sometimes true
    local w = self.scale * self.scaleX * self.sprite.image:getWidth() / quadCount
    local h = self.scale * self.scaleY * self.sprite.image:getHeight()
    local x = self.actor:globalPos().x - w/2
    local y = self.actor:globalPos().y - h/2
    return x, y, w, h
end

function SpriteRenderer:hasAnimation(animName)
    return self.sprite and self.sprite.animations[animName]
end

return SpriteRenderer