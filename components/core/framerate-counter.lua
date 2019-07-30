local FramerateCounter = {}

registerComponent(FramerateCounter, "FramerateCounter")

local font = love.graphics.newFont(64)

function FramerateCounter:awake()
    self.framerate = 0
end

function FramerateCounter:draw(x, y)
    if DEBUG then
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.setFont(font)
        love.graphics.print(math.floor(self.framerate), love.graphics.getWidth() / 2)
    end
end

function FramerateCounter:update(dt)
    self.framerate = 1 / dt
end

return FramerateCounter
