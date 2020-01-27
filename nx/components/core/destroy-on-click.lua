local DestroyOnClick = {}

registerComponent(DestroyOnClick, "DestroyOnClick")

function DestroyOnClick:awake()
    self.actor:addComponentSafe(Components.Hoverable)
    self.actor:addComponentSafe(Components.HoverableRenderer)
    self.actor:addComponentSafe(Components.Clickable)
end

function DestroyOnClick:Clickable_onClickOn(button)
    if button == 1 then
        self.actor:destroy()
    end
end

return DestroyOnClick
