local MatchBoundingBoxWith = {}

registerComponent(MatchBoundingBoxWith,'MatchBoundingBoxWith', {'BoundingBox'})

function MatchBoundingBoxWith:setup(actor,v,y)
    assert(actor.BoundingBox)
    self.offset = Vector.new(v,y)
    self.child = actor
end

function MatchBoundingBoxWith:update(dt)
    local rect = self.actor.BoundingBox:getRect()
    rect:grow(self.offset.x,-self.offset.y)

    self.child.BoundingBox:setDimensions(rect:wh())
    self.child.AffixPos.offset = self.offset:clone()
end

return MatchBoundingBoxWith