local List = require("nx/list")

local tempBuffer = List.new()

function debugLog(str, ...)
    str = tostring(str)
    for i, v in ipairs({...}) do
        str = str .. "\t" .. tostring(v)
    end

    if sceneLayers then
        local debugScene = sceneLayers:getDebugScene()
        print(debugScene)
        if debugScene then
            local debugRenderer = debugScene:getFirstBehavior(Components.DebugLogRenderer)
            if debugRenderer then
                if tempBuffer:length() > 0 then
                    for i, v in tempBuffer:each() do
                        list:add(v)
                    end
                    tempBuffer:clear()
                end

                debugRenderer:append(str)
                print(str)
            end
        end
    else
        list:add(str)
    end
end
