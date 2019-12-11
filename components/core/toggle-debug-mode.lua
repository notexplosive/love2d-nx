local ToggleDebugMode = {}

registerComponent(ToggleDebugMode, "ToggleDebugMode")

function ToggleDebugMode:awake()
    self.isCtrlDown = false
end

function ToggleDebugMode:onKeyPress(key, scancode, wasRelease)
    if key == "lctrl" or key == "rctrl" then
        self.isCtrlDown = not wasRelease
    end

    if self.isCtrlDown and key == "`" and not wasRelease and ALLOW_DEBUG then
        DEBUG = not DEBUG
    end
end

return ToggleDebugMode
