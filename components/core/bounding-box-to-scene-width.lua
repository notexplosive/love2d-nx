local BoundingBoxToSceneWidth = {}

registerComponent(BoundingBoxToSceneWidth, "BoundingBoxToSceneWidth")

function BoundingBoxToSceneWidth:setup(rightBuffer)
    self.rightBuffer = rightBuffer
end

function BoundingBoxToSceneWidth:awake()
    self:update()
end

function BoundingBoxToSceneWidth:update(dt)
    self.actor.BoundingBox:setWidth(self.actor:scene().width - (self.rightBuffer or 0))
end

return BoundingBoxToSceneWidth
