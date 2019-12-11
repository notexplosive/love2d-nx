local SelectOnResize = {}

registerComponent(SelectOnResize, "SelectOnResize", {"Selectable", "BoundingBoxEditor"})

function SelectOnResize:BoundingBoxEditor_onResizeStart()
    self.actor.Selectable:select()
end

return SelectOnResize
