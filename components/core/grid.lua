local Grid = {}

registerComponent(Grid, "Grid")

function Grid:setup(cellWidth, cellHeight)
    self.cellSize = Size.new(cellWidth, cellHeight)
end

function Grid:snap(actor)
    actor:setPos(self:snapToVector(actor:pos()))
end

function Grid:snapVector(v, y)
    local v = Vector.new(v, y)
    return Vector.new(
        self:roundToNearestNumber(v.x, self.cellSize.width),
        self:roundToNearestNumber(v.y, self.cellSize.height)
    )
end

function Grid:roundToNearestNumber(number, increment)
    if number % increment > increment / 2 then
        roundUp = true
    end

    if roundUp then
        return number - number % increment + increment
    else
        return number - number % increment
    end
end

return Grid
