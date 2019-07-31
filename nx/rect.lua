local Test = require("nx/test")
local Vector = require("nx/vector")
local Size = require("nx/size")
local Rect = {}

function Rect.new(x, y, width, height)
    local self = newObject(Rect)

    assert(x)
    assert(y)

    self.pos = Vector.new(x, y)
    self.size = Size.new(width or 0, height or 0)

    return self
end

function Rect:width()
    return self.size.width
end

function Rect:height()
    return self.size.height
end

function Rect:x()
    return self.pos.x
end

function Rect:y()
    return self.pos.y
end

function Rect:wh()
    return self.size:wh()
end

function Rect:inflate(dx, dy)
    assert(dx, "Rect:inflate() needs a 2 arguments")
    assert(dy, "Rect:inflate() needs a 2 arguments")
    self.pos = self.pos - Vector.new(dx, dy) / 2
    self.size:grow(dx, dy)
end

function Rect:area()
    return self.size:area()
end

function Rect:getIntersection(other)
    local left = math.max(self:x(), other:x())
    local right = math.min(self:x() + self:width(), other:x() + other:width())
    local top = math.max(self:y(), other:y())
    local bottom = math.min(self:y() + self:height(), other:y() + other:height())

    if left < right and top < bottom then
        return Rect.new(left, top, right - left, bottom - top)
    else
        return Rect.new(0, 0, 0, 0)
    end
end

function Rect:xy()
    return self:x(), self:y()
end

function Rect:xywh()
    return self:x(), self:y(), self.size:wh()
end

function Rect:asTwoVectors()
    return self.pos:clone(), self.pos:clone() + Vector.new(self.size.width, self.size.height)
end

function Rect:isVectorWithin(v,y)
    assert(v,"isVectorWithin needs an argument")
    local vector = Vector.new(v,y)
    local cond1 = vector.x > self:x()
    local cond2 = vector.x < self:x() + self:width()
    local cond3 = vector.y > self:y()
    local cond4 = vector.y < self:y() + self:height()

    return cond1 and cond2 and cond3 and cond4
end

----

Test.run(
    "Rect",
    function()
        local testRect1 = Rect.new(10, 20, 300, 400)
        local testRect2 = Rect.new(0, 10, 100, 32)

        -- Test the accessors
        local w1, h1 = testRect1:wh()
        Test.assert(300, testRect1:width(), "Rect:width()")
        Test.assert(400, testRect1:height(), "Rect:height()")
        Test.assert(10, testRect1:x(), "Rect:x()")
        Test.assert(20, testRect1:y(), "Rect:y()")
        Test.assert(w1, testRect1:width(), "Rect:width()")
        Test.assert(h1, testRect1:height(), "Rect:height()")
        Test.assert(100, testRect2:width(), "Rect:width() of a different rect")

        -- Test inflate
        testRect2:inflate(100, 100)
        Test.assert(200, testRect2:width(), "Width after Rect:inflate")
        Test.assert(132, testRect2:height(), "Height after Rect:inflate")

        Test.assert(-50, testRect2:x(), "Height after Rect:inflate")
        Test.assert(-40, testRect2:y(), "Height after Rect:inflate")

        -- Test intersection
        local leftRect = Rect.new(0, 0, 100, 100)
        local rightRect = Rect.new(50, 25, 100, 100)
        local intersection = leftRect:getIntersection(rightRect)
        Test.assert(50, intersection:width(), "Intersection width")
        Test.assert(75, intersection:height(), "Intersection height")
        Test.assert(50, intersection:x(), "Intersection x")
        Test.assert(25, intersection:y(), "Intersection y")

        -- Test asTwoVectors
        local cornerRect = Rect.new(123, 456, 100, 200)
        local v1, v2 = cornerRect:asTwoVectors()
        Test.assert(123, v1.x, "testing a corner of asTwoVectors")
        Test.assert(456, v1.y, "testing a corner of asTwoVectors")
        Test.assert(223, v2.x, "testing a corner of asTwoVectors")
        Test.assert(656, v2.y, "testing a corner of asTwoVectors")

        -- Test isVectorWithin
        local surface = Rect.new(100, 100, 100, 100)
        local pointInside = Vector.new(150, 150)
        local pointOnBoundary = Vector.new(100, 100)
        local pointOutside = Vector.new(50, 150)
        Test.assert(true, surface:isVectorWithin(pointInside), "Rect:isVectorWithinRect(), pointInside")
        Test.assert(false, surface:isVectorWithin(pointOnBoundary), "Rect:isVectorWithinRect(), pointOnBoundary")
        Test.assert(false, surface:isVectorWithin(pointOutside), "Rect:isVectorWithinRect(), pointOutside")
    end
)

return Rect
