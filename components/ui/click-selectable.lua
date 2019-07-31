local ClickSelectable = {}

registerComponent(ClickSelectable,'ClickSelectable')

function ClickSelectable:awake()
    self.actor:addComponentSafe(Components.BoundingBox)
    self.actor:addComponentSafe(Components.Hoverable)
    self.actor:addComponentSafe(Components.Clickable)

    self.actor:addComponentSafe(Components.Selectable,true)
end

function ClickSelectable:Clickable_onClickOn(button)
    if button == 1 and not self.actor.Selectable:selected() then
        self.actor.Selectable:select()
    end
end

return ClickSelectable