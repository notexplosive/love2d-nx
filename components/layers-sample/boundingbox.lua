local BoundingBox = {}

registerComponent(BoundingBox, "BoundingBox")

-- TODO: BoundingBox:init()

function BoundingBox:awake()
    self.boundingWidth = 64
    self.boundingHeight = 64
    self.boundingOffset = Vector.new(0, 0)
    self.forceCustom = false

    self.actor:createEvent("onCollide", {"otherActor"})
end

function BoundingBox:draw(x, y, inFocus)
end

function BoundingBox:update(dt, inFocus)
end

-- TODO: move all of this to new component
function BoundingBox:getRect()
    if self.actor.spriteRenderer and (self.boundingOffset.x == 0 or self.boundingOffset.y == 0) and not self.forceCustom then
        return self.spriteRenderer:getBoundingBox()
    end
    return self.actor.pos.x - self.boundingOffset.x, self.actor.pos.y - self.boundingOffset.y, self.boundingWidth, self.boundingHeight
end

function BoundingBox:setBoundingBoxDimensions(w, h)
    self.boundingWidth = w
    self.boundingHeight = h
end

function BoundingBox:isWithinBoundingBox(x, y)
    return isWithinBox(x, y, self:getRect())
end

function BoundingBox:isOutOfBounds()
    if self.actor.scene then
        local x, y, w, h = self:getRect()
        local x2, y2 = x + w, y + h
        return not isWithinBox(x, y, self.actor:scene():getBounds()) and not isWithinBox(x, y2, self.actor:scene():getBounds()) and
            not isWithinBox(x2, y, self.actor:scene():getBounds()) and
            not isWithinBox(x2, y2, self.actor:scene():getBounds())
    end

    print(self.actor.name .. " bounds check not applicable, no scene")
end

return BoundingBox
