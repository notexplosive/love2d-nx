local Test = require("nx/test")
local Vector = require("nx/vector")
local Size = require("nx/size")
local Rect = {}

function Rect.new(x, y, width, height)
    local self = newObject(Rect)

    assert(x)
    assert(y)

    if type(x) == 'table' then
        if x:type() == Vector and y:type() == Size then
            local vec = x
            local size = y
            return Rect.new(vec.x,vec.y,size.width,size.height)
        end
    end

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

function Rect:setWidth(width)
    self.size.width = width
end

function Rect:setHeight(height)
    self.size.height = height
end

function Rect:top()
    return self.pos.y
end

function Rect:bottom()
    return self.pos.y + self:height()
end

function Rect:left()
    return self.pos.x
end

function Rect:right()
    return self.pos.x + self:width()
end

function Rect:move(v,y)
    self.pos = self.pos + Vector.new(v,y)
    return self
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
    return self
end

function Rect:grow(dx,dy)
    self.size:grow(dx,dy)
    return self
end

function Rect:area()
    return self.size:area()
end

function Rect:dimensions()
    return self.size.width,self.size.height
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
        local inflateRect = Rect.new(0,0,10,10)
        inflateRect:inflate(100, 100)
        Test.assert(110, inflateRect:width(), "Width after Rect:inflate")
        Test.assert(110, inflateRect:height(), "Height after Rect:inflate")
        Test.assert(-50, inflateRect:x(), "x after Rect:inflate")
        Test.assert(-50, inflateRect:y(), "y after Rect:inflate")

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

        local mover = Rect.new(10,10,50,50)
        mover:move(5,10)
        Test.assert(15,mover.pos.x, "Move X")
        Test.assert(20,mover.pos.y, "Move Y")
        mover:setWidth(25)
        Test.assert(25,mover:width(),"Width after setWidth()")
        mover:setHeight(35)
        Test.assert(35,mover:height(),"Height after setHeight()")
        
        Test.assert(mover:top(),20,"top")
        Test.assert(mover:bottom(),55,"bottom")
        Test.assert(mover:left(),15,"left")
        Test.assert(mover:right(),40,"right")

        -- Alternate constructor
        local vecSizeRect = Rect.new(Vector.new(100,200), Size.new(400,500))
        Test.assert(100, vecSizeRect:x(), "Rect:x()")
        Test.assert(200, vecSizeRect:y(), "Rect:y()")
        Test.assert(400, vecSizeRect:width(), "Rect:width()")
        Test.assert(500, vecSizeRect:height(), "Rect:height()")
    end
)

return Rect
