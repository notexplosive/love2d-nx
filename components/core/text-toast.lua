local TextToast = {}

registerComponent(TextToast, "TextToast")

local font = love.graphics.newFont(50)

function TextToast:setup(text, font)
    self.text = text
    self.font = self.font or font
end

function TextToast:awake()
    self.text = ""
    self.font = font
    self.travelDistance = 100
    self.deltaY = self.travelDistance

    self.timer = 1
end

function TextToast:draw(x, y)
    local width = self.font:getWidth(self.text)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(self.font)
    love.graphics.printf(self.text, math.floor(x - width / 2), math.floor(y + self.deltaY - self.travelDistance), width, "center")
end

function TextToast:update(dt)
    if self.deltaY > 0 then
        self.deltaY = self.deltaY - dt * 300
    else
        self.timer = self.timer - dt
        if self.timer < 0 then
            self.actor:destroy()
        end
    end
end

return TextToast
