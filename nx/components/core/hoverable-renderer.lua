local HoverableRenderer = {}

registerComponent(HoverableRenderer, "HoverableRenderer")

function HoverableRenderer:draw(x, y)
    if self.actor.Hoverable:getHoverIgnoreConsume() then
        local rect = self.actor.BoundingBox:getDrawableRect():inflate(-5, -5)
        love.graphics.setColor(0, 0, 1)
        love.graphics.rectangle("line", rect:xywh())
    end

    if self.hover then
        local rect = self.actor.BoundingBox:getDrawableRect():inflate(-5, -5)
        love.graphics.setColor(0, 0.5, 1, 0.5)
        love.graphics.rectangle("fill", rect:xywh())
    end
end

function HoverableRenderer:Hoverable_onHover()
    self.hover = true
end

function HoverableRenderer:Hoverable_onHoverEnd()
    self.hover = false
end

return HoverableRenderer
