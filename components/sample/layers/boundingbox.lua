local BoundingBox = {}

registerComponent(BoundingBox, "BoundingBox")

-- TODO: BoundingBox:setup(w,h,ox,oy)
-- makes forceCustom = true
function BoundingBox:setup(w,h,ox,oy)
    self.forceCustom = true
    self.width = w
    self.height = h
    self.offset = Vector.new(ox,oy)
end


function BoundingBox:awake()
    self.width = 64
    self.height = 64
    self.offset = Vector.new(0, 0)
    self.forceCustom = false
    self.visible = true
end

function BoundingBox:draw(x, y)
    if self.visible then
        love.graphics.rectangle("line", self:getRect())
    end
end

function BoundingBox:getRect()
    if self.actor.SpriteRenderer and (self.offset.x == 0 or self.offset.y == 0) and not self.forceCustom then
        return self.actor.SpriteRenderer:getBoundingBox()
    end
    return self.actor:globalPos().x - self.offset.x, self.actor:globalPos().y - self.offset.y, self.width, self.height
end

function BoundingBox:setBoundingBoxDimensions(w, h)
    self.width = w
    self.height = h
    self.forceCustom = true
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
