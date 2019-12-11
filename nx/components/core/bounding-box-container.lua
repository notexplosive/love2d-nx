local BoundingBoxContainer = {}

registerComponent(BoundingBoxContainer, "BoundingBoxContainer", {"BoundingBox"})

function BoundingBoxContainer:setup(actor, v, y)
    assert(actor.BoundingBox)
    self.offset = Vector.new(v, y)
    self.child = actor
    self:adjust()
end

function BoundingBoxContainer:start()
    assert(self.child, "setup not run")
end

function BoundingBoxContainer:update(dt)
    self:adjust()
end

function BoundingBoxContainer:adjust()
    local rect = self.actor.BoundingBox:getRect()
    rect:grow(self.offset.x, -self.offset.y)

    self.child.BoundingBox:setDimensions(rect:wh())
    self.child.AffixPos.offset = self.offset:clone()
end

return BoundingBoxContainer
