local OutlineOnHover = {}

registerComponent(OutlineOnHover, "OutlineOnHover", {"Hoverable"})

function OutlineOnHover:draw(x, y)
    if self.isHovering then
        love.graphics.setColor(0, 0, 1, 1)
        love.graphics.rectangle("line", self.actor.BoundingBox:getRect():xywh())
    end
end

function OutlineOnHover:Hoverable_onHover()
    self.isHovering = true
end

function OutlineOnHover:Hoverable_onHoverEnd()
    self.isHovering = false
end

return OutlineOnHover
