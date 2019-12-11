local BoundedTextRenderer = {}

registerComponent(BoundedTextRenderer, "BoundedTextRenderer", {"BoundingBox"})

-- love.graphics.newFont is slow, so we cache all the fonts we create
local fontCache = {
    data = {},
    get = function(self, fontSize)
        fontSize = math.floor(fontSize)
        if self.data[fontSize] then
            return self.data[fontSize]
        else
            self.data[fontSize] = love.graphics.newFont(fontSize)
            return self.data[fontSize]
        end
    end
}

function BoundedTextRenderer:setup(text, fontSize, alignMode, scale, color, offsetx, offsety)
    self.text = text or self.text
    self.color = color or self.color
    self.alignMode = alignMode or self.alignMode
    self.scale = scale or self.scale
    self.font = fontCache:get(fontSize or 10)
    self.offset = Vector.new(offsetx, offsety)
    self.shadow = false
end

function BoundedTextRenderer:awake()
    self.text = ""
    self.alignMode = "left"
    self.scale = 1
    self.color = {1, 1, 1}
    self.font = fontCache:get(12)
    self.offset = Vector.new()
end

function BoundedTextRenderer:draw(x, y)
    love.graphics.setFont(self.font)

    if self.shadow then
        love.graphics.setColor(0, 0, 0)
        self:displayText(x + 1, y + 1)
    end

    love.graphics.setColor(self.color)
    self:displayText(x, y)
end

function BoundedTextRenderer:displayText(x, y)
    local text = self:ellideText(self.text)

    love.graphics.printf(
        tostring(text),
        math.floor(x),
        math.floor(y),
        self:getBoundedWidth(),
        self.alignMode,
        self.actor:angle(),
        self.scale,
        self.scale,
        math.floor(-self.offset.x),
        math.floor(-self.offset.y)
    )
end

function BoundedTextRenderer:setFontSize(size)
    self.font = fontCache:get(size)
end

function BoundedTextRenderer:getWrap(optionalText)
    local width, lines = self.font:getWrap(optionalText or self.text, self:getBoundedWidth() or 0)
    local widthLastLine = width
    if lines[1] then
        widthLastLine = self.font:getWrap(lines[#lines], self:getBoundedWidth() or 0)
    end
    return width, lines, widthLastLine
end

function BoundedTextRenderer:ellideText(text)
    local width, lines, widthLastLine = self:getWrap(text)

    local useLines = {}
    local lineCount = 1
    for height = self.font:getHeight(), self:getBoundedHeight(), self.font:getHeight() do
        useLines[lineCount] = lines[lineCount]
        lineCount = lineCount + 1
    end

    return string.join(useLines, "\n")
end

function BoundedTextRenderer:getFont()
    return self.font
end

function BoundedTextRenderer:getBoundedWidth()
    return self.actor.BoundingBox:width()
end

function BoundedTextRenderer:getBoundedHeight()
    return self.actor.BoundingBox:height()
end

function BoundedTextRenderer:getNeededHeight()
    local width, lines, widthLastLine = self:getWrap()
    return #lines * self.font:getHeight()
end

function BoundedTextRenderer:getTextWidth(text)
    local width, lines, widthLastLine = self:getWrap(text or self.text)
    if #lines == 1 then
        return self.font:getWidth(text or self.text)
    end
    return width
end

return BoundedTextRenderer
