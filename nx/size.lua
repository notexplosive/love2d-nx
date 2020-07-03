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

function Size.__mul(left, right)
    if type(left) == "number" then
        return Size.new(left * right.width, left * right.height)
    end

    if type(right) == "number" then
        return Size.new(right * left.width, right * left.height)
    end
end

function Size.__div(left, right)
    if type(left) == "number" then
        return Size.new(right.width / left, right.height / left)
    end

    if type(right) == "number" then
        return Size.new(left.width / right, left.height / right)
    end
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
