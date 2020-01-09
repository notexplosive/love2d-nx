local Vector = {}

function Vector.new(x, y)
    assert(x ~= Vector, "Use Vector.new not Vector:new")
    if type(x) == "table" then
        return x:clone()
    end

    local vector = newObject(Vector)
    vector.x = x or 0
    vector.y = y or 0
    return vector
end

function Vector.newPolar(distance, angle)
    assert(type(angle) == "number", "angle is not a number")
    assert(distance, "distance is nil")
    return Vector.new(distance, 0):setAngle(angle)
end

function Vector.newCardinal(name, magnitude)
    assert(name, "Vector.newCardinal was passed a nil")
    assert(type(name) == "string", "Vector.newCardinal takes a string, given " .. type(name))
    magnitude = magnitude or 1
    if name == "north" or name == "up" then
        return Vector.new(0, -1) * magnitude
    end

    if name == "south" or name == "down" then
        return Vector.new(0, 1) * magnitude
    end

    if name == "right" or name == "east" then
        return Vector.new(1, 0) * magnitude
    end

    if name == "left" or name == "west" then
        return Vector.new(-1, 0) * magnitude
    end

    assert(false, "No cardinal direction called " .. name)
end

function Vector:toString()
    return "(" .. self.x .. "," .. self.y .. ")"
end

function Vector.__eq(lhs, rhs)
    return lhs.x == rhs.x and lhs.y == rhs.y
end

function Vector.__add(left, right)
    assert(right, "attempted to add a nil vector (right side)")
    assert(left, "attempted to add to a nil vector (left side)")
    assert(right:type() == Vector, "attempted to add a nonvector (right side)")
    assert(left:type() == Vector, "attempted to add to a nonvector (left side)")
    return Vector.new(left.x + right.x, left.y + right.y)
end

function Vector.__sub(left, right)
    assert(right, "attempted to subtract a nil vector (right side)")
    assert(left, "attempted to subtract from a nil vector (left side)")
    assert(right:type() == Vector, "attempted to subtract a nonvector (right side)")
    assert(left:type() == Vector, "attempted to subtract from a nonvector (left side)")
    return Vector.new(left.x - right.x, left.y - right.y)
end

function Vector.__mul(left, right)
    if type(left) == "number" then
        return Vector.new(left * right.x, left * right.y)
    end

    if type(right) == "number" then
        return Vector.new(right * left.x, right * left.y)
    end
end

function Vector.__div(left, right)
    if type(left) == "number" then
        return Vector.new(right.x / left, right.y / left)
    end

    if type(right) == "number" then
        return Vector.new(left.x / right, left.y / right)
    end
end

function Vector.__unm(v)
    return Vector.new(-v.x, -v.y)
end

function Vector:clone()
    return Vector.new(self.x, self.y)
end

function Vector:distanceTo(v)
    return (self - v):length()
end

function Vector:toString()
    return self.x .. ", " .. self.y
end

function Vector:getCardinalName()
    if self.y == 0 then
        if self.x > 0 then
            return "right"
        end
        if self.x < 0 then
            return "left"
        end
    end

    if self.x == 0 then
        if self.y > 0 then
            return "down"
        end
        if self.y < 0 then
            return "up"
        end
    end

    return nil
end

function Vector:xy()
    return self.x, self.y
end

function Vector:floor()
    self.x = math.floor(self.x)
    self.y = math.floor(self.y)
    return self
end

function Vector:length()
    return math.sqrt((self.x * self.x) + (self.y * self.y))
end

function Vector:normalized()
    local l = self:length()
    if l == 0 then
        return Vector.new(0, 0)
    end
    return Vector.new(self.x / l, self.y / l)
end

function Vector:dot(other)
    return self.x * other.x + self.y * other.y
end

function Vector:rotate(theta)
    local x = self.x
    local y = self.y

    self.x = x * math.cos(theta) - y * math.sin(theta)
    self.y = x * math.sin(theta) + y * math.cos(theta)

    return self
end

function Vector:setAngle(theta)
    local length = self:length()
    self.x = math.cos(theta) * length
    self.y = math.sin(theta) * length
    return self
end

function Vector:angle()
    if self.x == 0 then
        if self.y > 0 then
            return math.pi / 2
        else
            return -math.pi / 2
        end
    end

    a = math.atan(self.y / self.x)

    if self.x > 0 and self.y > 0 then
        a = math.abs(a)
    else
        if self.x < 0 then
            a = a + math.pi
            if a > math.pi then
                a = a - math.pi * 2
            end
        else
            a = -math.abs(a)
        end
    end

    return a
end

local Test = require("nx/test")
Test.run(
    "Vector",
    function()
        local down = Vector.new(0, 1)
        local left = Vector.new(-1, 0)
        local right = Vector.new(1, 0)
        local up = Vector.new(0, -1)

        Test.assert("down", down:getCardinalName(), "Cardinal name down")
        Test.assert("left", left:getCardinalName(), "Cardinal name left")
        Test.assert("right", right:getCardinalName(), "Cardinal name right")
        Test.assert("up", up:getCardinalName(), "Cardinal name up")
    end
)

return Vector
