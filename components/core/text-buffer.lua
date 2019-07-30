local TextBuffer = {}

registerComponent(TextBuffer, "TextBuffer")


function TextBuffer:awake()
    love.keyboard.setKeyRepeat(true)
    self.active = false
    self:clear()
end

function TextBuffer:onTextInput(text)
    if self.active then
        self.text = self.text .. text
    end
end

function TextBuffer:onKeyPress(key, scancode, wasRelease)
    if self.active then
        if not wasRelease then
            if key == "backspace" then
                self.text = string.sub(self.text, 1, -2)
            end

            if key == "return" then
                self.actor:callForAllComponents("TextBuffer_onSubmit", self.text)
                self:clear()
            end
        end
    end
end

--
-- public api
--

function TextBuffer:clear()
    self.text = ""
end

function TextBuffer:activate()
    self.active = true
end

function TextBuffer:deactivate()
    self.active = false
end

return TextBuffer
