local Sprite = {}

-- Called by templating code, should never be called directly.
function Sprite.new(filename, gridSizeX, gridSizeY)
    local self = newObject(Sprite)
    self.filename = filename
    self.image = love.graphics.newImage(filename)
    self.image:setFilter("nearest", "nearest")
    self.quads = {}
    self.animations = {}

    if gridSizeX == nil then
        gridSizeX = self.image:getWidth()
        gridSizeY = self.image:getHeight()
    end

    for y = 0, self.image:getHeight() - gridSizeY, gridSizeY do
        for x = 0, self.image:getWidth() - gridSizeX, gridSizeX do
            if x ~= self.image:getWidth() and y ~= self.image:getHeight() then
                self.quads[#self.quads + 1] =
                    love.graphics.newQuad(x, y, gridSizeX, gridSizeY, self.image:getDimensions())
            end
        end
    end
    
    self.gridWidth = gridSizeX
    self.gridHeight = gridSizeY

    self:createAnimation("all", 1, #self.quads)
    return self
end

-- Called by templating code, should never be called directly.
function Sprite:createAnimation(animName, startQuad, endQuad)
    self.animations[animName] = {
        first = startQuad,
        last = endQuad,
        name = animName
    }
end

function Sprite:getAllAnimations()
    local names = getKeys(self.animations)
    local anims = {}
    for i, name in ipairs(names) do
        anims[i] = self.animations[name]
    end
    return anims
end

-- Helper function for things that want to draw sprites that aren't spriterenderers
function Sprite:draw(quadIndex, x, y, offx, offy, angle, scale, color, flipX)
    if not quadIndex or quadIndex < 1 then
        return
    end

    if color then
        love.graphics.setColor(color)
    else
        love.graphics.setColor(1, 1, 1, 1)
    end

    assert(self.quads[quadIndex], "No quad at index " .. quadIndex .. " on sprite " .. self.filename)

    local xScale = scale or 1
    if flipX then xScale = -xScale end

    love.graphics.draw(
        self.image,
        self.quads[quadIndex],
        x,
        y,
        angle or 0,
        xScale,
        scale or 1,
        offx or self.gridWidth / 2,
        offy or self.gridHeight / 2
    )
end

return Sprite
