local FramerateCounter = {}

registerComponent(FramerateCounter, "FramerateCounter")

local font = love.graphics.newFont(64)

function FramerateCounter:draw(x, y)
    if DEBUG then
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.setFont(font)
        love.graphics.print(love.timer.getFPS(), love.graphics.getWidth() / 2)
    end
end

return FramerateCounter
