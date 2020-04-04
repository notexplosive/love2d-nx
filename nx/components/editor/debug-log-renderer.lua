local DebugLogRenderer = {}

registerComponent(DebugLogRenderer, "DebugLogRenderer")

local fontHeight = 20
local font = love.graphics.newFont(fontHeight)

local fadeOutDuration = 1
local timeBeforeFade = 3

function DebugLogRenderer:awake()
    self.content = List.new()
    self.timer = 0
    self.opacity = 0
end

function DebugLogRenderer:start()
    if DEBUG then
        debugLog("DebugMode is enabled")
        debugLog(love.window.getTitle())
    end
end

function DebugLogRenderer:draw(x, y)
    love.graphics.setFont(font)

    love.graphics.setColor(0, 0, 0, self.opacity * 0.25)
    love.graphics.rectangle(
        "fill",
        x,
        y - fontHeight * (self.content:length() - 1),
        love.graphics.getWidth(),
        fontHeight * self.content:length()
    )

    for i, str in self.content:cloneReversed():each() do
        love.graphics.setColor(0.1, 0.1, 0.1, self.opacity)
        love.graphics.print(str, x + 1, y - (i - 1) * fontHeight + 1)
        love.graphics.setColor(1, 1, 1, self.opacity)
        love.graphics.print(str, x, y - (i - 1) * fontHeight)
    end

    self.actor:setPos(0, self.actor:scene().height / 2 - fontHeight)
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
    self.content:add(str)
    self.timer = timeBeforeFade + fadeOutDuration
end

return DebugLogRenderer
