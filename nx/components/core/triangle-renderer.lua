local TriangleRenderer = {}

registerComponent(TriangleRenderer, "TriangleRenderer")

function TriangleRenderer:setup(size, color)
    self.size = size
    self.color = color
end

function TriangleRenderer:reverseSetup()
    return self.size, self.color
end

function TriangleRenderer:draw(x, y)
    local pos = Vector.new(x, y)
    local angle = self.actor:angle() - math.pi / 2
    local v = -Vector.newPolar(self.size, angle)
    local bottom = v + pos
    local top = Vector.newPolar(self.size, angle) + pos
    local leftFoot = Vector.newPolar(self.size, angle + math.pi / 2) + v + pos
    local rightFoot = Vector.newPolar(self.size, angle - math.pi / 2) + v + pos

    love.graphics.setColor(self.color or {1, 1, 1, 1})
    love.graphics.polygon("fill", top.x, top.y, leftFoot.x, leftFoot.y, rightFoot.x, rightFoot.y)

    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.polygon("line", top.x, top.y, leftFoot.x, leftFoot.y, rightFoot.x, rightFoot.y)
end

return TriangleRenderer
