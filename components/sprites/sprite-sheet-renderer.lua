local SpriteSheetRenderer = {}

registerComponent(SpriteSheetRenderer, "SpriteSheetRenderer")

function SpriteSheetRenderer:setup(spriteName, scale)
    assert(spriteName, "Sprite name cannot be nil")
    assert(Assets[spriteName], "No sprite named " .. spriteName)

    self.sprite = Assets[spriteName]
    self.scale = scale or self.scale
end

function SpriteSheetRenderer:awake()
    self.sprite = nil
    self.scale = 1
end

function SpriteSheetRenderer:draw(x, y)
    for i, _ in ipairs(self.sprite.quads) do
        local fx, fy = self:getFrameCoords(i, x, y)

        for j, animName in ipairs(getKeys(self.sprite.animations)) do
            local anim = self.sprite.animations[animName]
            if anim.first == i then
                local numberOfFrames = anim.last - anim.first + 1
                local w, h = self:getFrameDimensions()
                w = w * numberOfFrames
                love.graphics.setColor(1, 1, 1)
                love.graphics.print(anim.name, fx, fy + 16 + 16 * j)
                love.graphics.setColor(1, 1, 1, 0.5)
                love.graphics.rectangle("line", fx, fy, w, h)
            end
        end

        local mx, my = self.actor:scene():getMousePosition()
        if isWithinBox(mx, my, fx, fy, self:getFrameDimensions()) then
            love.graphics.setColor(1, 1, 1, 0.25)
            love.graphics.rectangle("fill", fx, fy, self:getFrameDimensions())

            -- draw preview of selected frame
            self.sprite:draw(
                i,
                x,
                y,
                self.sprite.gridWidth / 2,
                self.sprite.gridHeight * self.scale / 2,
                0,
                self.scale * 2
            )
        end

        self.sprite:draw(i, fx, fy, 0, 0, 0, self.scale)
    end
end

function SpriteSheetRenderer:getFrameCoords(i, x, y)
    local gw = self.sprite.gridWidth
    return i * gw * self.scale + x, y
end

function SpriteSheetRenderer:getFrameDimensions()
    return self.sprite.gridWidth * self.scale, self.sprite.gridHeight * self.scale
end

return SpriteSheetRenderer
