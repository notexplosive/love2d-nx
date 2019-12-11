local BringToFrontOnSelect = {}

registerComponent(BringToFrontOnSelect, "BringToFrontOnSelect", {"Selectable"})

function BringToFrontOnSelect:Selectable_onSelect()
    self.actor:scene():bringToFront(self.actor)
end

return BringToFrontOnSelect
