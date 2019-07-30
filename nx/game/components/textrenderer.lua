local TextRenderer = {}

registerComponent(TextRenderer, "TextRenderer")

-- love.graphics.newFont is slow, so we cache all the fonts we create
local fontCache = {
    data = {},
    get = function(self,fontSize)
        fontSize = math.floor(fontSize)
        if self.data[fontSize] then
            return self.data[fontSize]
        else
            self.data[fontSize] = love.graphics.newFont(fontSize)
            return self.data[fontSize]
        end
    end
}

function TextRenderer.create_object()
    return newObject(TextRenderer)
end

function TextRenderer:setup(text, fontSize, maxWidth, alignMode, scale, color, offsetx, offsety)
    self.text = text or self.text
    self.color = color or self.color
    self.maxWidth = maxWidth or self.maxWidth
    self.alignMode = alignMode or self.alignMode
    self.scale = scale or self.scale
    self.font = fontCache:get(fontSize)
    self.offset = Vector.new(offsetx, offsety)
    self.shadow = false
end

function TextRenderer:awake()
    self.text = ""
    self.maxWidth = nil
    self.alignMode = "left"
    self.scale = 1
    self.color = {1, 1, 1}
    self.font = fontCache:get(12)
    self.offset = Vector.new()
end

function TextRenderer:draw()
    love.graphics.setFont(self.font)

    if not self.maxWidth then
        self.maxWidth = self.actor:scene().width - self.actor:pos().x
    end

    -- Gross corner case for centering
    local offsetX = 0
    if self.alignMode == "center" then
        offsetX = self.maxWidth / 2
    end

    if self.shadow then
        love.graphics.setColor(0, 0, 0)
        love.graphics.printf(
            self.text,
            math.floor(self.actor:pos().x + 1),
            math.floor(self.actor:pos().y + 1),
            self.maxWidth,
            self.alignMode,
            self.actor:angle(),
            self.scale,
            self.scale,
            math.floor(-self.offset.x + offsetX),
            math.floor(-self.offset.y)
        )
    end

    love.graphics.setColor(self.color)
    love.graphics.printf(
        self.text,
        math.floor(self.actor:pos().x),
        math.floor(self.actor:pos().y),
        self.maxWidth,
        self.alignMode,
        self.actor:angle(),
        self.scale,
        self.scale,
        math.floor(-self.offset.x + offsetX),
        math.floor(-self.offset.y)
    )
end

function TextRenderer:update(dt)
end

function TextRenderer:getWrap()
    local width, lines = self.font:getWrap(self.text, self.maxWidth or 0)
    local widthLastLine = width
    if lines[1] then
        widthLastLine = self.font:getWrap(lines[#lines], self.maxWidth or 0)
    end
    return width, lines, widthLastLine
end

function TextRenderer:getFont()
    return self.font
end

return TextRenderer
