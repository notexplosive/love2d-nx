local Cursor = {}

registerComponent(Cursor, "Cursor")

function Cursor:awake()
    self.size = 20
    self.press = false
end

function Cursor:draw(x, y)
    local fill = "fill"
    love.graphics.setColor(1, 1, 1, 1)
    if self.press then
        fill = "line"
    end
    love.graphics.circle(fill, x, y, self.size)
    love.graphics.setColor(1, 1, 1)
end

function Cursor:onMouseMove(x, y, dx, dy)
    self.actor:setLocalPos(x, y)
end

function Cursor:onMousePress(x, y, button, wasRelease)
    self.press = wasRelease
end

function Cursor:onScroll(x,y)
    self.size = self.size + y
    if self.size < 5 then self.size = 5 end
end

return Cursor
