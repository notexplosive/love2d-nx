local BoundingBoxEditorRenderer = {}

registerComponent(BoundingBoxEditorRenderer, "BoundingBoxEditorRenderer", {"BoundingBoxEditor"})

function BoundingBoxEditorRenderer:draw(x, y)
    love.graphics.setColor(1, 1, 1, 1)
    for i, rect in ipairs(self.actor.BoundingBoxEditor.sideGrabHandleRects) do
        local fill = "fill"
        if self.actor.BoundingBoxEditor.selectedIndex == i then
            fill = "line"
        end
        love.graphics.rectangle(fill, rect:xywh())
    end

    for i, rect in ipairs(self.actor.BoundingBoxEditor.cornerGrabHandleRects) do
        local fill = "fill"
        if self.actor.BoundingBoxEditor.selectedIndex == i + 4 then
            fill = "line"
        end
        love.graphics.rectangle(fill, rect:xywh())
    end
end

return BoundingBoxEditorRenderer
