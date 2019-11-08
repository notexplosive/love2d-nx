local GridRenderer = {}

registerComponent(GridRenderer, "GridRenderer", {"Grid"})

function GridRenderer:setup(horizontalCount, verticalCount)
    self.size = Size.new(horizontalCount, verticalCount)
end

function GridRenderer:draw(x, y)
    local rect = Rect.new(Vector.new(x, y), self.actor.Grid.cellSize)
    for i = 0, self.size.width do
        for j = 0, self.size.height do
            local w, h = rect:wh()
            love.graphics.rectangle("line", i * w + x, j * h + y, w, h)
        end
    end
end

function GridRenderer:update(dt)
end

return GridRenderer
