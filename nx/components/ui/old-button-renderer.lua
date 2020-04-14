local OldButtonRenderer = {}

registerComponent(OldButtonRenderer, "OldButtonRenderer", {"Hoverable"})

local font = love.graphics.newFont(16)

function OldButtonRenderer:setup(name)
    self.name = name
end

function OldButtonRenderer:awake()
    self.name = ""
end

function OldButtonRenderer:draw(x, y)
    local pressed = false
    if self.actor.Clickable then
        pressed = self.actor.Clickable.currentPressedButton == 1
    end

    local hover = self.actor.Hoverable:getHoverConsume()

    love.graphics.setColor(0.5, 0, 0)
    if hover then
        love.graphics.setColor(0, 0.5, 0)
        if pressed then
            love.graphics.setColor(0, 0, 0.5)
        end
    end

    love.graphics.rectangle("fill", x, y, self.actor.BoundingBox:getDimensions())
    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(defaultFont, font)
    love.graphics.print(self.name, math.floor(x), math.floor(y))
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("line", x, y, self.actor.BoundingBox:getDimensions())
end

return OldButtonRenderer
