local Size = {}

function Size.new(width, height)
    local self = newObject(Size)
    self.width = width or 0
    self.height = height or 0
    return self
end

function Size.fromVector(vector)
    return Size.new(vector.x, vector.y)
end

function Size:clone()
    return Size.new(self.width, self.height)
end

function Size.__eq(lhs, rhs)
    return lhs.width == rhs.width and lhs.height == rhs.height
end

function Size:grow(dx, dy)
    self.width = self.width + dx
    self.height = self.height + dy
end

function Size:area()
    return self.width * self.height
end

function Size:wh()
    return self.width, self.height
end

function Size:clone()
    return Size.new(self:wh())
end

return Size
