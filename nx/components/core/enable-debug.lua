local EnableDebug = {}

registerComponent(EnableDebug, "EnableDebug")

function EnableDebug:onKeyPress(key, scancode, wasRelease)
    if key == "`" and not wasRelease then
        DEBUG = not DEBUG
    end
end

return EnableDebug
