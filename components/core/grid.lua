local Grid = {}

registerComponent(Grid, "Grid")

function Grid:setup(cellWidth, cellHeight)
    self.cellSize = Size.new(cellWidth, cellHeight)
end

function Grid:snapActor(actor)
    actor:setPos(self:snapVector(actor:pos()))
end

function Grid:snapVector(v, y)
    local v = Vector.new(v, y)
    local l = self.actor:pos().x % self.cellSize.width
    local ll = self.actor:pos().y % self.cellSize.height

    return Vector.new(
        self:roundToNearestNumber(v.x - l, self.cellSize.width) + l,
        self:roundToNearestNumber(v.y - ll, self.cellSize.height) + ll
    )
end

function Grid:roundToNearestNumber(number, increment)
    if number % increment > increment / 2 then
        roundUp = true
    end

    if roundUp then
        return number - number % increment
    else
        return number - number % increment - increment
    end
end

return Grid
