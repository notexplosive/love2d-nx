local BoundingBoxToSceneHeight = {}

registerComponent(BoundingBoxToSceneHeight, "BoundingBoxToSceneHeight")

function BoundingBoxToSceneHeight:setup(bottomBuffer)
    self.bottomBuffer = bottomBuffer
end

function BoundingBoxToSceneHeight:awake()
    self:update()
end

function BoundingBoxToSceneHeight:update(dt)
    self.actor.BoundingBox:setHeight(self.actor:scene().height - (self.bottomBuffer or 0))
end

return BoundingBoxToSceneHeight
