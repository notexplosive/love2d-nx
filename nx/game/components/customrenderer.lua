local CustomRenderer = {}

CustomRenderer.name = 'customRenderer'
registerComponent(CustomRenderer)

function CustomRenderer.create()
    return newObject(CustomRenderer)
end

function CustomRenderer:draw(x,y)
    -- left blank so it can be overridden
end

return CustomRenderer