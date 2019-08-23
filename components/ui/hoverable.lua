local Hoverable = {}

registerComponent(Hoverable, "Hoverable")

function Hoverable:awake()
    self.wasHovered = false
end

function Hoverable:onMouseMove(x, y, dx, dy, isConsumed)
    self.cachedMousePos = Vector.new(x, y)

    if isConsumed then
        if self.wasHovered then
            self.actor:callForAllComponents("Hoverable_onUnhover")
            self.wasHovered = false
        end
        return
    end

    if self:getHover() then
        self.actor:callForAllComponents("Hoverable_onHover")
        self.actor:scene():consumeHover()
        self.wasHovered = true
    else
        self.actor:callForAllComponents("Hoverable_onUnhover")
        self.wasHovered = false
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
