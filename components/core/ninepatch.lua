local NinePatch = {}

registerComponent(NinePatch, "NinePatch", {"BoundingBox"})

function NinePatch:setup(imageName)
    self.sprite = Assets[imageName]
    self.spriteName = imageName
end

function NinePatch:reverseSetup()
    return self.spriteName
end

function NinePatch:draw(x, y)
    local truncatedWidth, truncatedHeight = self.actor.BoundingBox:getDimensions()
    truncatedWidth = truncatedWidth - 16 - truncatedWidth % 16
    truncatedHeight = truncatedHeight - 16 - truncatedHeight % 16
    local realWidth, realHeight = self.actor.BoundingBox:getDimensions()

    --[[
        1 2 3 4
        5 6 7 8
        9 10 11 12
        13 14 15 16
    ]]
    
    -- For debugging
    local color = {1,1,1,1}
    
    -- fill in the middle
    for dx = 16, truncatedWidth, 16 do
        for dy = 16, truncatedHeight, 16 do
            local drawPos = Vector.new(dx + x, dy + y)
            self.sprite:draw(6, drawPos.x, drawPos.y, 0, 0,0,1,color)
        end
    end

    -- left side
    for dy = 16, truncatedHeight, 16 do
        local drawPos = Vector.new(x, dy + y)
        self.sprite:draw(5, drawPos.x, drawPos.y, 0, 0,0,1,color)
    end

    -- right side (anchored to right)
    for dy = 16, truncatedHeight, 16 do
        local drawPos = Vector.new(x + realWidth - 16, dy + y)
        self.sprite:draw(8, drawPos.x, drawPos.y, 0, 0,0,1,color)
    end

    -- bottom (anchored to bottom)
    for dx = 16, truncatedWidth, 16 do
        local drawPos = Vector.new(dx + x, realHeight - 16 + y)
        self.sprite:draw(14, drawPos.x, drawPos.y, 0, 0,0,1,color)
    end

    -- top
    for dx = 16, truncatedWidth, 16 do
        local drawPos = Vector.new(dx + x,y)
        self.sprite:draw(2, drawPos.x, drawPos.y, 0, 0,0,1,color)
    end

    -- corners
    self.sprite:draw(1, x, y, 0, 0,0,1,color)
    self.sprite:draw(4, realWidth + x - 16, y, 0, 0,0,1,color)
    self.sprite:draw(13, x, realHeight + y - 16, 0, 0,0,1,color)
    self.sprite:draw(16, realWidth + x - 16, realHeight + y - 16, 0, 0,0,1,color)
end

return NinePatch
