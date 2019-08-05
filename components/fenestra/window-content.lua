local WindowContent = {}

registerComponent(WindowContent, "WindowContent")

function WindowContent:awake()
    local child = self.actor:scene():addActor("Resizer")
    child:addComponent(Components.BoundingBox)
    child:addComponent(Components.AffixPos,self.actor)
    child:addComponent(Components.Canvas,0,16,0,-16)
    child:addComponent(Components.DrawRandomShit)
    self.child = child

    self.actor.BoundingBoxEditor.topOffset = 16

    self:BoundingBoxEditor_onResizeEnd(self.actor.BoundingBox:getRect())
end

function WindowContent:update(dt)
    local width,height = self.actor.BoundingBox:getDimensions()
    self.child.BoundingBox:setDimensions(width,height)
end

function WindowContent:BoundingBoxEditor_onResizeStart()
    self.child:callForAllComponents("BoundingBoxEditor_onResizeStart")
end

function WindowContent:BoundingBoxEditor_onResizeEnd(rect)
    self.child:callForAllComponents("BoundingBoxEditor_onResizeEnd", rect)
end

function WindowContent:BoundingBoxEditor_onResizeDrag(rect)
    self.child:callForAllComponents("BoundingBoxEditor_onResizeDrag", rect)
end


return WindowContent
