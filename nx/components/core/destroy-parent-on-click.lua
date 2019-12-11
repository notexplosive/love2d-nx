local DestroyParentOnClick = {}

registerComponent(DestroyParentOnClick, "DestroyParentOnClick", {"Clickable", "Parent"})

function DestroyParentOnClick:Clickable_onClickOn()
    self.actor.Parent:get():destroy()
end

return DestroyParentOnClick
