local DraggableRectHeight = {}

registerComponent(DraggableRectHeight,'DraggableRectHeight',{"Draggable","BoundingBox"})

function DraggableRectHeight:setup(height,verticalOffset)
    self.customHeight = height
    self.verticalOffset = verticalOffset or 0
end

function DraggableRectHeight:start()
    assert(self.customHeight,"setup was not run")
end

function DraggableRectHeight:update(dt)
    local rect = self.actor.BoundingBox:getRect()
    rect:setHeight(self.customHeight)
    rect:move(0,self.verticalOffset)
    self.actor.Draggable.customRect = rect
end

return DraggableRectHeight