local RectRenderer = {}

registerComponent(RectRenderer, "RectRenderer")

function RectRenderer:setup(width, height, color, offsetV, offsetY)
    assert(width)
    assert(height)
    self.width = width
    self.height = height
    self.color = color
    self.offset = Vector.new(offsetV, offsetY)
end

function RectRenderer:reverseSetup()
    return self.width, self.height, self.color, self.offsetV, self.offsetY
end

function RectRenderer:BoundingBox_deferredSetup()
    self.actor.BoundingBox:setup(
        self.width * 2,
        self.height * 2,
        self.width + self.offset.x,
        self.height + self.offset.y
    )
end

function RectRenderer:draw(x, y)
    love.graphics.setColor(self.color or {1, 1, 1, 1})

    local left = -self.width
    local top = -self.height
    local right = self.width
    local bottom = self.height

    local vectors = {
        Vector.new(x, y) + (Vector.new(left, top) - self.offset):rotate(self.actor:angle()),
        Vector.new(x, y) + (Vector.new(right, top) - self.offset):rotate(self.actor:angle()),
        Vector.new(x, y) + (Vector.new(right, bottom) - self.offset):rotate(self.actor:angle()),
        Vector.new(x, y) + (Vector.new(left, bottom) - self.offset):rotate(self.actor:angle())
    }

    local points = self:flatten(vectors)

    love.graphics.polygon("fill", points)

    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.polygon("line", points)

    if DEBUG then
    --love.graphics.circle("line", x, y, 5)
    end
end

function RectRenderer:getDimensions()
    return self.width, self.height
end

-- extract me!!
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
