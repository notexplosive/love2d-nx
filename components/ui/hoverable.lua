local Hoverable = {}

registerComponent(Hoverable, "Hoverable")

function Hoverable:onMouseMove(x, y, dx, dy)
    self.cachedMousePos = Vector.new(x, y)
    if self:getHover() then
        self.actor:callForAllComponents("Hoverable_onHover")
    else
        self.actor:callForAllComponents("Hoverable_onUnhover")
    end
end

function Hoverable:getHoverOfPoint(v, y)
    local x, y = Vector.new(v, y):xy()
    return self.actor.BoundingBox:getRect():isVectorWithin(x,y)
end

function Hoverable:getHover()
    return self:getHoverOfPoint(self.cachedMousePos)
end

return Hoverable
