local RectRenderer = {}

registerComponent(RectRenderer, "RectRenderer")

function RectRenderer:setup(width, height, color)
    assert(width)
    assert(height)
    self.width = width
    self.height = height
    self.color = color
end

function RectRenderer:draw(x, y)
    love.graphics.setColor(self.color or {1, 1, 1, 1})

    local left = -self.width / 2
    local top = -self.height / 2
    local right = self.width / 2
    local bottom = self.height / 2

    local vectors = {
        Vector.new(x, y) + Vector.new(left, top):rotate(self.actor:angle()),
        Vector.new(x, y) + Vector.new(right, top):rotate(self.actor:angle()),
        Vector.new(x, y) + Vector.new(right, bottom):rotate(self.actor:angle()),
        Vector.new(x, y) + Vector.new(left, bottom):rotate(self.actor:angle())
    }

    local points = self:flatten(vectors)

    love.graphics.polygon("fill", points)

    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.polygon("line", points)
end

function RectRenderer:flatten(vectors)
    local points = {}
    local size = 1

    for i, vector in ipairs(vectors) do
        points[size] = vector.x
        size = size + 1
        points[size] = vector.y
        size = size + 1
    end

    return points
end

return RectRenderer
