local DebugRenderer = {}

registerComponent(DebugRenderer,'DebugRenderer')

local fontHeight = 20
local font = love.graphics.newFont(fontHeight)

local fadeOutDuration = 1
local timeBeforeFade = 3

function DebugRenderer:awake()
    self.content = {}
    self.timer = 0
    self.opacity = 0

    self._contentSize = 0
end

function DebugRenderer:start()
    if DEBUG then
        debugLog(love.window.getTitle())
        debugLog("DebugMode is enabled")
    end
end

function DebugRenderer:draw(x,y)
    love.graphics.setFont(font)
    love.graphics.setColor(1,1,1,self.opacity)
    for i,str in ipairs(copyReversed(self.content)) do
        love.graphics.print(str,x,y - (i-1) * fontHeight)
    end

    self.actor:setPos(0,self.actor:scene().height/2 - fontHeight)

    love.graphics.setColor(1,1,1,1)
end

function DebugRenderer:update(dt)
    self.timer = self.timer - dt
    if self.timer < fadeOutDuration then
        self.opacity = self.timer / fadeOutDuration
    else
        self.opacity = 1
    end

    if self.timer < 0 then
        self.content = {}
        self._contentSize = 0
    end
end

function DebugRenderer:append(str)
    self._contentSize = self._contentSize + 1
    self.content[self._contentSize] = str
    self.timer = timeBeforeFade + fadeOutDuration
end

return DebugRenderer