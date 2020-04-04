local DebugLogRenderer = {}

registerComponent(DebugLogRenderer, "DebugLogRenderer")

local fontHeight = 20
local font = love.graphics.newFont(fontHeight)

local fadeOutDuration = 1
local timeBeforeFade = 3
local maxBufferSize = 10

function DebugLogRenderer:awake()
    self.content = List.new()
    self.timer = 0
    self.opacity = 0
end

function DebugLogRenderer:draw(x, y)
    love.graphics.setFont(font)

    love.graphics.setColor(0, 0, 0, self.opacity * 0.25)
    love.graphics.rectangle(
        "fill",
        x,
        y - fontHeight * (maxBufferSize - 1) + fontHeight * (maxBufferSize - 1),
        love.graphics.getWidth(),
        fontHeight * self.content:length()
    )

    for i, str in self.content:cloneReversed():each() do
        local printY = y + (i) * fontHeight - fontHeight * maxBufferSize + fontHeight * (maxBufferSize - 1)
        love.graphics.setColor(0.1, 0.1, 0.1, self.opacity)
        love.graphics.print(str, x + 1, printY + 1)
        love.graphics.setColor(1, 1, 1, self.opacity)
        love.graphics.print(str, x, printY)
    end
end

function DebugLogRenderer:update(dt)
    self.timer = self.timer - dt
    if self.timer < fadeOutDuration then
        self.opacity = self.timer / fadeOutDuration
    else
        self.opacity = 1
    end

    if self.timer < 0 then
        self.content:clear()
    end
end

function DebugLogRenderer:append(str)
    self.content:enqueue(str)
    self.timer = timeBeforeFade + fadeOutDuration

    if self.content:length() > maxBufferSize then
        self.content:pop()
    end
end

return DebugLogRenderer
