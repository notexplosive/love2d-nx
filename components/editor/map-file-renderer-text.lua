local MapFileRendererText = {}

registerComponent(MapFileRendererText, "MapFileRendererText", {"MapFile"})

function MapFileRendererText:draw(x, y)
    love.graphics.setColor(1, 0.5, 1, 1)
    local text = self.actor.MapFile:getSceneJson()
    text = string.gsub(text, ",", ", ")
    love.graphics.print(text, x, y + 22)
end

return MapFileRendererText
