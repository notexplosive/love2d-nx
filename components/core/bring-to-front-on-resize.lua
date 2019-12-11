local BringToFrontOnResize = {}

registerComponent(BringToFrontOnResize, "BringToFrontOnResize", {"Selectable"})

function BringToFrontOnResize:BoundingBoxEditor_onResizeDrag()
    self.actor:scene():bringToFront(self.actor)
end

return BringToFrontOnResize
