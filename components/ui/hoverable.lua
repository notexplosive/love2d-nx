local Hoverable = {}

registerComponent(Hoverable, "Hoverable")

function Hoverable:onMouseMove(x, y, dx, dy)
    self.cachedMousePos = Vector.new(x, y)
    if self:getHover(x, y) then
        self.actor:callForAllComponents("Hoverable_onHover")
    else
        self.actor:callForAllComponents("Hoverable_onUnhover")
    end
end

function Hoverable:getHover(v, y)
    local x, y = Vector.new(v, y):components()
    return isWithinRect(x, y, self.actor.BoundingBox:getRect())
end

return Hoverable
