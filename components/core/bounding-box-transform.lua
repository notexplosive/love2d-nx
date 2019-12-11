local BoundingBoxTransform = {}

registerComponent(BoundingBoxTransform, "BoundingBoxTransform", {"BoundingBox"})

function BoundingBoxTransform:setup(targetWidth, targetHeight)
    self.targetSize = Size.new(targetWidth, targetHeight)

    self.isShrinkingWidth = self.targetSize.width < self.actor.BoundingBox:width()
    self.isShrinkingHeight = self.targetSize.height < self.actor.BoundingBox:height()
end

function BoundingBoxTransform:update(dt)
    local factor = 0.25
    local widthDelta = math.abs(self.targetSize.width - self.actor.BoundingBox:width()) * factor * dt * 60
    local heightDelta = math.abs(self.targetSize.height - self.actor.BoundingBox:height()) * factor * dt * 60

    if self.isShrinkingWidth then
        widthDelta = -widthDelta
    end
    if self.isShrinkingHeight then
        heightDelta = -heightDelta
    end

    self.actor.BoundingBox:setDimensions(
        self.actor.BoundingBox:width() + widthDelta,
        self.actor.BoundingBox:height() + heightDelta
    )
end

return BoundingBoxTransform
