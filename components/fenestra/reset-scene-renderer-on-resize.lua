local ResetCanvasSizeOnResize = {}

registerComponent(ResetCanvasSizeOnResize,'ResetCanvasSizeOnResize',{'Canvas'})

function ResetCanvasSizeOnResize:update(dt)
    if self.actor.BoundingBox:getSize() ~= self.cachedSize then
        self.actor.Canvas:setDimensions(self.actor.BoundingBox:getDimensions())
    end

    self.cachedSize = self.actor.BoundingBox:getSize()
end

return ResetCanvasSizeOnResize