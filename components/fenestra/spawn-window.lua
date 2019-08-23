local SpawnWindow = {}

registerComponent(SpawnWindow, "SpawnWindow")

function SpawnWindow:awake()
    local scene = self.actor:scene()
    local container = scene:addActor("Container")
    local canvas = scene:addActor("Canvas")

    container:addComponent(Components.BoundingBox, 500, 500)
    container:addComponent(Components.BoundingBoxEditor)

    canvas:addComponent(Components.BoundingBox)
    canvas:addComponent(Components.Hoverable)

    canvas:addComponent(Components.AffixPos, container)
    container:addComponent(Components.BoundingBoxContainer, canvas, 0, 32)

    --canvas:addComponent(Components.NinePatch, "windowchrome", 64, 64)
    canvas:addComponent(Components.Canvas)
    canvas:addComponent(Components.SceneRenderer, "hover-land")
    canvas:addComponent(Components.ResetCanvasSizeOnResize) -- todo: convert this to "DetectResize" which fires an event for SceneRenderer and canvas

    container:addComponent(Components.Hoverable)
    container:addComponent(Components.Clickable)
    container:addComponent(Components.Draggable)
    container:addComponent(Components.MoveOnDrag)

    if DEBUG then
        container:addComponent(Components.BoundingBoxRenderer)
        container:addComponent(Components.HoverableRenderer)

        if container.BoundingBoxEditor then
            container:addComponent(Components.BoundingBoxEditorRenderer)
        end        

        canvas:addComponent(Components.BoundingBoxRenderer)
        canvas:addComponent(Components.HoverableRenderer)
    end
end

return SpawnWindow
