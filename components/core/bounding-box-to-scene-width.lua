local BoundingBoxToSceneWidth = {}

registerComponent(BoundingBoxToSceneWidth,'BoundingBoxToSceneWidth')

function BoundingBoxToSceneWidth:update(dt)
    self.actor.BoundingBox:setWidth(self.actor:scene().width)
end

return BoundingBoxToSceneWidth