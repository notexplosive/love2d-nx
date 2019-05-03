local FormatPrinter = {}

registerComponent(FormatPrinter, "FormatPrinter")

function FormatPrinter:setup(text)
    self.text = text
end

function FormatPrinter:awake()
    self.text = ""
end

function FormatPrinter:draw(x, y)
    love.graphics.setColor(1,1,1)
    love.graphics.printf(self.text, 0, 0, self.actor:scene().width, "left")
end

function FormatPrinter:update(dt)
end

return FormatPrinter
