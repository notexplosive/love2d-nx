local BoundingBoxOffsetToCenter = {}

registerComponent(BoundingBoxOffsetToCenter, "BoundingBoxOffsetToCenter", {"BoundingBox"})

function BoundingBoxOffsetToCenter:awake()
    local v1, v2 = self.actor.BoundingBox:getRect():asTwoVectors()
    local center = v1 - self.actor:pos() + (v2 - self.actor:pos()) / 2
    self.actor.BoundingBox.offset = center
end

return BoundingBoxOffsetToCenter
