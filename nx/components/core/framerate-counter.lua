local FramerateCounter = {}

registerComponent(FramerateCounter, "FramerateCounter")

local font = love.graphics.newFont(64)

function FramerateCounter:draw(x, y)
    if ALLOW_DEBUG then
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.setFont(font)
        love.graphics.print(love.timer.getFPS(), love.graphics.getWidth() - font:getWidth(love.timer.getFPS()))
    end
end

return FramerateCounter
