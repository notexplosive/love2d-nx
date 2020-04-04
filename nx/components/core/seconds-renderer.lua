local sceneLayers = require("nx/scene-layers")
local SecondsRenderer = {}

registerComponent(SecondsRenderer, "SecondsRenderer")

function SecondsRenderer:awake()
    self.time = 0
end

function SecondsRenderer:draw(x, y)
    local size = 32
    local cx = math.cos(self.time - math.pi / 2) * size
    local cy = math.sin(self.time - math.pi / 2) * size

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.circle("fill", x, y, size)
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.circle("line", x, y, size)
    love.graphics.setColor(0, 0, 0, 1)

    for i = 0, math.pi * 2, math.pi / 5 do
        local dx = math.cos(i) * size
        local dy = math.sin(i) * size
        love.graphics.line(x + dx * 0.9, y + dy * 0.9, x + dx * 0.95, y + dy * 0.95)
    end

    love.graphics.setColor(0.5, 0, 0, 1)
    love.graphics.line(x, y, x + cx * 0.9, y + cy * 0.9)
end

function SecondsRenderer:setTime(time)
    self.time = time
end

return SecondsRenderer
