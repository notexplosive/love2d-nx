local sceneLayers = require("nx/scene-layers")

function debugLog(str, ...)
    str = tostring(str)
    for i, v in ipairs({...}) do
        str = str .. "\t" .. tostring(v)
    end

    local debugScene = sceneLayers:peek()
    if debugScene then
        local debugRenderer = debugScene:getFirstBehavior(Components.DebugRenderer)
        if debugRenderer then
            debugRenderer:append(str)
            print(str)
        end
    end
end
