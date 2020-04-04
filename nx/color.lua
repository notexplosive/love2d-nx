local Color = {}

function Color.new(r, g, b, a)
    local self = newObject(Color)

    assert(r, "Red channel is nil")
    assert(g, "Green channel is nil")
    assert(b, "Blue channel is nil")
    self.rgba = {}

    self:setRed(r)
    self:setGreen(g)
    self:setBlue(b)
    self:setAlpha(a)

    return self
end

function Color:red()
    return self.rgba[1]
end

function Color:green()
    return self.rgba[2]
end

function Color:blue()
    return self.rgba[3]
end

function Color:alpha()
    return self.rgba[4]
end

function Color:setRed(c)
    c = clamp(c, 0, 1)
    self.rgba[1] = c
end

function Color:setGreen(c)
    c = clamp(c, 0, 1)
    self.rgba[2] = c
end

function Color:setBlue(c)
    c = clamp(c, 0, 1)
    self.rgba[3] = c
end

function Color:setAlpha(c)
    c = clamp(c, 0, 1)
    self.rgba[4] = c
end

function Color:add(color)
    return Color.new(
        self:red() + color:red(),
        self:green() + color:green(),
        self:blue() + color:blue(),
        self:alpha() + color:alpha()
    )
end

function Color:subtract(color)
    return Color.new(
        self:red() - color:red(),
        self:green() - color:green(),
        self:blue() - color:blue(),
        self:alpha() - color:alpha()
    )
end

function Color.__add(left, right)
    assert(right, "attempted to add a nil color (right side)")
    assert(left, "attempted to add to a nil color (left side)")
    assert(right:type() == Color, "attempted to add a noncolor (right side)")
    assert(left:type() == Color, "attempted to add to a noncolor (left side)")
    return left:add(right)
end

function Color.__sub(left, right)
    assert(right, "attempted to subtract a nil color (right side)")
    assert(left, "attempted to subtract to a nil color (left side)")
    assert(right:type() == Color, "attempted to subtract a noncolor (right side)")
    assert(left:type() == Color, "attempted to subtract to a noncolor (left side)")
    return left:subtract(right)
end

function Color:rgbTable()
    return {self:red(), self:green(), self:blue()}
end

function Color:rgbaTable()
    return {self:red(), self:green(), self:blue(), self:alpha()}
end

-- Tests
local Test = require("nx/test")
Test.run(
    "Color",
    function()
        -- CONSTRUCTOR TESTS
        local subject = Color.new(0.35, 0.75, 0.85, 0.95)
        Test.assert(0.35, subject:red(), "Constructor sets red")
        Test.assert(0.75, subject:green(), "Constructor sets green")
        Test.assert(0.85, subject:blue(), "Constructor sets blue")
        Test.assert(0.95, subject:alpha(), "Constuctor sets alpha")

        -- SETTERS TESTS
        subject = Color.new(0, 0, 0, 0)
        subject:setRed(0.5)
        subject:setGreen(0.6)
        subject:setBlue(0.7)
        subject:setAlpha(0.8)
        Test.assert(0.5, subject:red(), "Setter sets red")
        Test.assert(0.6, subject:green(), "Setter sets red")
        Test.assert(0.7, subject:blue(), "Setter sets red")
        Test.assert(0.8, subject:alpha(), "Setter sets alpha")

        -- CLAMP TESTS
        subject = Color.new(0.5, 0.5, 0.5, 0.5)
        subject:setRed(2)
        subject:setGreen(55)
        subject:setBlue(-1)
        subject:setAlpha(-200)
        Test.assert(1, subject:red(), "Value clamps to 1")
        Test.assert(1, subject:green(), "Value clamps to 1")
        Test.assert(0, subject:blue(), "Value clamps to 0")
        Test.assert(0, subject:alpha(), "Value clamps to 0")

        -- ADD/SUBTRACT TESTS
        local left = Color.new(0.2, 0.3, 0.4, 0.5)
        local right = Color.new(0.1, 0.2, 0.3, 0.4)
        local added = left + right
        Test.assert({0.3, 0.5, 0.7, 0.9}, added:rgbaTable(), "Table")
        local subtracted = left - right
        Test.assert({0.1, 0.1, 0.1, 0.1}, subtracted:rgbaTable(), "Table")
    end
)

return Color
