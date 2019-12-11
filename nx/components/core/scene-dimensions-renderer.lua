local SceneDimensionsRenderer = {}

registerComponent(SceneDimensionsRenderer, "SceneDimensionsRenderer")

function SceneDimensionsRenderer:draw(x, y)
    love.graphics.setColor(0, 0, 1, 1)
    love.graphics.rectangle("fill", x, y, self.actor:scene().width, self.actor:scene().height)
end

return SceneDimensionsRenderer
