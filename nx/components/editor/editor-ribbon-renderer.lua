local EditorRibbonBackground = {}

registerComponent(EditorRibbonBackground,'EditorRibbonBackground')

function EditorRibbonBackground:draw(x,y)
    love.graphics.setColor(0,0,0.25)

    local rect = Rect.new(x, y, self.actor.BoundingBox:getDimensions())
    love.graphics.rectangle('fill', rect:xywh())

    rect:inflate(-4,-4)
    love.graphics.setColor(1,1,0.75)
    love.graphics.rectangle('fill', rect:xywh())

    rect:inflate(-2,-2)
    love.graphics.setColor(0,0,0.25)
    love.graphics.rectangle('fill', rect:xywh())
end

return EditorRibbonBackground