local Keybind = {}

registerComponent(Keybind, "Keybind")

function Keybind:onKeyPress(key, scancode, wasRelease)
    local fullyQualifiedKey = ""

    if love.keyboard.isDown("rctrl") or love.keyboard.isDown("lctrl") then
        fullyQualifiedKey = fullyQualifiedKey .. "^"
    end

    if love.keyboard.isDown("rshift") or love.keyboard.isDown("lshift") then
        fullyQualifiedKey = fullyQualifiedKey .. "+"
    end

    if love.keyboard.isDown("ralt") or love.keyboard.isDown("lalt") then
        fullyQualifiedKey = fullyQualifiedKey .. "*"
    end

    if not wasRelease then
        self.actor:callForAllComponents("Keybind_onPress", fullyQualifiedKey .. key)
    end
end

return Keybind
