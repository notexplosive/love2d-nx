local TextInput = {}

registerComponent(TextInput, "TextInput")

function TextInput:setup(cursorThickness)
    self.cursorThickness = cursorThickness
end

function TextInput:awake()
    self.prefix = ""
    if not self.actor.BoundedTextRenderer then
        self.actor:addComponent(Components.BoundedTextRenderer, "", 14, "left", 1, {1, 1, 1, 1}, 0, 0)
    end
    self.text = self.actor.BoundedTextRenderer.text
    self.cursorX = 0

    self.cursorThickness = 5
end

function TextInput:draw(x, y)
    local textUpToCursor = self:getText():sub(1, self.cursorX)
    local textRenderer = self.actor.BoundedTextRenderer
    local cursorDrawX = x + textRenderer:getTextWidth(self.prefix .. textUpToCursor) + textRenderer.offset.x + 1
    local cursorDrawY = y + textRenderer.offset.y

    if self:isSelected() then
        love.graphics.setColor(textRenderer.color)
        love.graphics.rectangle(
            "fill",
            cursorDrawX,
            cursorDrawY,
            self.cursorThickness,
            textRenderer:getFont():getHeight() - 1
        )
    end

    textRenderer.text = self.prefix .. self.text
end

function TextInput:onKeyPress(button, scancode, wasRelease)
    if not self:isSelected() then
        return
    end

    if not wasRelease then
        if button == "right" then
            self.cursorX = self.cursorX + 1
        end

        if button == "left" then
            self.cursorX = self.cursorX - 1
        end

        if button == "home" then
            self.cursorX = 0
        end

        if button == "end" then
            self.cursorX = #self:getText()
        end

        if button == "backspace" and self.cursorX > 0 then
            local left = self:getText():sub(1, self.cursorX - 1)
            local right = self:getText():sub(self.cursorX + 1, #self:getText())
            self.cursorX = self.cursorX - 1
            self:setText(left .. right)
        end

        if button == "return" then
            self.actor:callForAllComponents("TextInput_onSubmit", self:getText(), self.prefix)
        end

        self.cursorX = clamp(self.cursorX, 0, #self:getText())
    end
end

function TextInput:onTextInput(text)
    if not self:isSelected() then
        return
    end

    local left = self:getText():sub(1, self.cursorX)
    local middle = text
    local right = self:getText():sub(self.cursorX + 1, #self:getText())
    self.cursorX = self.cursorX + 1
    self:setText(left .. middle .. right)
end

function TextInput:getText()
    return self.text
end

function TextInput:setText(text)
    self.text = text
end

function TextInput:isSelected()
    if self.actor.Selectable then
        return self.actor.Selectable:selected()
    else
        return true
    end
end

return TextInput
