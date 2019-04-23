local BoundingBox = {}

registerComponent(BoundingBox, "BoundingBox")

-- TODO: BoundingBox:init(w,h,ox,oy)
-- makes forceCustom = true

function BoundingBox:awake()
    self.width = 64
    self.height = 64
    self.offset = Vector.new(0, 0)
    self.forceCustom = false
end

function BoundingBox:draw(x, y, inFocus)
end

function BoundingBox:update(dt, inFocus)
end

-- TODO: move all of this to new component
function BoundingBox:getRect()
    if self.actor.spriteRenderer and (self.offset.x == 0 or self.offset.y == 0) and not self.forceCustom then
        return self.spriteRenderer:getBoundingBox()
    end
    return self.actor.pos.x - self.offset.x, self.actor.pos.y - self.offset.y, self.width, self.height
end

function BoundingBox:setBoundingBoxDimensions(w, h)
    self.width = w
    self.height = h
end

function BoundingBox:isWithinBoundingBox(x, y)
    return isWithinBox(x, y, self:getRect())
end

function BoundingBox:isOutOfBounds()
    if self.actor.scene then
        local x, y, w, h = self:getRect()
        local x2, y2 = x + w, y + h
        return not isWithinBox(x, y, self.actor:scene():getBounds()) and
            not isWithinBox(x, y2, self.actor:scene():getBounds()) and
            not isWithinBox(x2, y, self.actor:scene():getBounds()) and
            not isWithinBox(x2, y2, self.actor:scene():getBounds())
    end

    print(self.actor.name .. " bounds check not applicable, no scene")
end

return BoundingBox
