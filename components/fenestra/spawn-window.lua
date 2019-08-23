local SpawnWindow = {}

registerComponent(SpawnWindow,'SpawnWindow')

function SpawnWindow:awake()
    local scene = self.actor:scene()
    local container = scene:addActor('Container')
    local canvas = scene:addActor('Canvas')

    container:addComponent(Components.BoundingBox)
    container:addComponent(Components.BoundingBoxEditor)

    canvas:addComponent(Components.BoundingBox)
    canvas:addComponent(Components.Hoverable)

    container:addComponent(Components.WindowContainer):setup(canvas)
    container:addComponent(Components.MatchBoundingBoxWith,canvas,0,32)

    container:addComponent(Components.Hoverable)
    container:addComponent(Components.Clickable)
    container:addComponent(Components.Draggable)
    container:addComponent(Components.MoveOnDrag)

    if DEBUG then
        container:addComponent(Components.BoundingBoxRenderer)
        container:addComponent(Components.BoundingBoxEditorRenderer)
        container:addComponent(Components.HoverableRenderer)

        canvas:addComponent(Components.BoundingBoxRenderer)
        canvas:addComponent(Components.HoverableRenderer)
    end
end

return SpawnWindow