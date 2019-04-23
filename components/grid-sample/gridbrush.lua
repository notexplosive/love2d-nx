local GridBrush = {}

registerComponent(GridBrush, "GridBrush")

function GridBrush:awake()
    self.colorIndex = 1
    self.palette = {
        {1,0,0},
        {0,1,0},
        {0,0,1},
    }
end

function GridBrush:draw(x, y)
    love.graphics.setColor(1, 1, 1)
    love.graphics.print(self.colorIndex)
end

function GridBrush:onScroll(x, y)
    if y > 0 then
        y = 1
    end
    if y < 0 then
        y = -1
    end
    local newIndex = self.colorIndex + y
    if newIndex < 1 then
        newIndex = #self.palette
    end

    if newIndex > #self.palette then
        newIndex = 1
    end

    self.colorIndex = newIndex
end

function GridBrush:getColor(index)
    return self.palette[index]
end

return GridBrush
