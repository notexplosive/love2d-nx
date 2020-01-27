local Sprite = {}

function Sprite.new(filename, gridSizeX, gridSizeY)
    local self = newObject(Sprite)
    self.filename = filename
    self.image = love.graphics.newImage(filename)
    self.image:setFilter("nearest", "nearest")
    self.animations = {}
    self.gridWidth = gridSizeX
    self.gridHeight = gridSizeY
    self.quads = {}

    assert(
        self.image:getWidth() % self.gridWidth == 0,
        filename .. ": Image width " .. self.image:getWidth() .. " is not divisible by Quad width " .. self.gridWidth
    )
    assert(
        self.image:getHeight() % self.gridHeight == 0,
        filename ..
            ": Image height " .. self.image:getHeight() .. " is not divisible by Quad height " .. self.gridHeight
    )

    self.quad = love.graphics.newQuad(0, 0, self.gridWidth, self.gridHeight, self.image:getDimensions())

    local rows = self.image:getWidth() / self.gridWidth
    local cols = self.image:getHeight() / self.gridHeight
    self.frames = cols * rows

    self:createAnimation("all", 1, self.frames)
    return self
end

function Sprite:getQuadAt(index)
    assert(index > 0 and index <= self.frames, "Attempted to index quad " .. index .. ", expected 0 to " .. self.frames)
    index = math.floor(index) - 1
    local fullWidth = self.gridWidth * index
    local x = fullWidth % self.image:getWidth()
    local y = 0
    while fullWidth > self.image:getWidth() - self.gridWidth do
        y = y + self.gridHeight
        fullWidth = fullWidth - self.image:getWidth()
    end

    if not self.quads[index] then
        self.quads[index] = love.graphics.newQuad(x, y, self.gridWidth, self.gridHeight, self.image:getDimensions())
    end

    return self.quads[index]
end

function Sprite:createAnimation(animName, startQuad, endQuad)
    self.animations[animName] = {
        first = startQuad,
        last = endQuad,
        name = animName
    }
end

function Sprite:getAllAnimations()
    local names = getKeys(self.animations)
    local anims = {}
    for i, name in ipairs(names) do
        anims[i] = self.animations[name]
    end
    return anims
end

function Sprite:draw(quadIndex, x, y, offx, offy, angle, scaleX, scaleY, color)
    if not quadIndex or quadIndex < 1 then
        return
    end

    if color then
        love.graphics.setColor(color)
    else
        love.graphics.setColor(1, 1, 1, 1)
    end

    love.graphics.draw(
        self.image,
        self:getQuadAt(quadIndex),
        math.floor(x),
        math.floor(y),
        angle or 0,
        scaleX or 1,
        scaleY or 1,
        offx or self.gridWidth / 2,
        offy or self.gridHeight / 2
    )
end

local Test = require("nx/test")
Test.run(
    "Sprite",
    function()
        local subject = Sprite.new("assets/images/numbers.png", 8, 16)

        Test.assert(subject.frames, 20, "Count quads")

        local x, y, width, height = subject:getQuadAt(1):getViewport()
        Test.assert(8, width, "Get quad width")
        Test.assert(16, height, "Get quad height")

        Test.assert(0, x, "Get first quad x")
        Test.assert(0, y, "Get first quad y")

        local x2, y2, width2, height2 = subject:getQuadAt(11):getViewport()
        Test.assert(0, x2, "Get middle quad x")
        Test.assert(16, y2, "Get middle quad y")

        local x3, y3, width3, height3 = subject:getQuadAt(12):getViewport()
        Test.assert(8, x3, "Get middle+1 quad x")
        Test.assert(16, y3, "Get middle+1 quad y")
    end
)

return Sprite
