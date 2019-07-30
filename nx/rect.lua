local Test = require("nx/test")
local Vector = require("nx/vector")
local Size = require("nx/size")
local Rect = {}

function Rect.new(x, y, width, height)
    local self = newObject(Rect)

    assert(x)
    assert(y)

    self.pos = Vector.new(x, y)
    self.size = Size.new(width, height)

    return self
end

function Rect:width()
    return self.size.width
end

function Rect:height()
    return self.size.height
end

function Rect:x()
    local keys = getKeys(self.pos)
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

function Rect:xywh()
    return self.pos.x, self.pos.y, self.size:wh()
end

----

Test.register(
    "Rect",
    function()
        local testRect1 = Rect.new(10, 20, 300, 400)
        local testRect2 = Rect.new(0, 10, 100, 32)

        -- The basics
        local w1, h1 = testRect1:wh()
        Test.assert(300, testRect1:width(), "Rect:width()")
        Test.assert(400, testRect1:height(), "Rect:height()")
        Test.assert(10, testRect1:x(), "Rect:x()")
        Test.assert(20, testRect1:y(), "Rect:y()")
        Test.assert(w1, testRect1:width(), "Rect:width()")
        Test.assert(h1, testRect1:height(), "Rect:height()")
        Test.assert(100, testRect2:width(), "Rect:width(), with a different rect")

        testRect2:inflate(100, 100)
        Test.assert(200, testRect2:width(), "Width after Rect:inflate")
        Test.assert(132, testRect2:height(), "Height after Rect:inflate")

        Test.assert(-50, testRect2:x(), "Height after Rect:inflate")
        Test.assert(-40, testRect2:y(), "Height after Rect:inflate")
    end
)

return Rect
