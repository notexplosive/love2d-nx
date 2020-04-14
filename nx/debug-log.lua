local List = require("nx/list")

local tempBuffer = List.new()

function debugLog(str, ...)
    str = tostring(str)
    for i, v in ipairs({...}) do
        str = str .. "\t" .. tostring(v)
    end

    if sceneLayers then
        local debugScene = sceneLayers:getDebugScene()
        if debugScene then
            local debugRenderer = debugScene:getFirstBehaviorIfExists(Components.DebugLogRenderer)
            if debugRenderer then
                if tempBuffer:length() > 0 then
                    for i, v in tempBuffer:each() do
                        debugRenderer:append(v)
                    end
                    tempBuffer:clear()
                end

                debugRenderer:append(str)
                print(str)
            else
                tempBuffer:add(str)
            end
        else
            tempBuffer:add(str)
        end
    else
        tempBuffer:add(str)
    end
end
