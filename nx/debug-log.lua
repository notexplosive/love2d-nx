function debugLog(str, ...)
    str = tostring(str)
    for i, v in ipairs({...}) do
        str = str .. "\t" .. tostring(v)
    end

    if uiScene then
        local debugRenderer = uiScene:getFirstBehavior(Components.DebugRenderer)
        if debugRenderer then
            debugRenderer:append(str)
            print(...)
        end
    end
end
