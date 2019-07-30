local TextBufferRenderer = {}

registerComponent(TextBufferRenderer, "TextBufferRenderer", {"TextBuffer"})

function TextBufferRenderer:awake()
    self.width = 500
    self.height = 20
    self.font = love.graphics.newFont(self.height)
end

function TextBufferRenderer:draw(x, y)
    if self.actor.TextBuffer.active then
        love.graphics.setColor(1,1,1,1)
        love.graphics.setFont(self.font)
        love.graphics.printf(self.actor.TextBuffer.text, x - self.width / 2, y, self.width, "left")

        love.graphics.rectangle("line", x - self.width / 2, y, self.width, self.height)
    end
end

function TextBufferRenderer:update(dt)
end

return TextBufferRenderer
