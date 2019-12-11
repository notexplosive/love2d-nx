local SelectOnClick = {}

registerComponent(SelectOnClick, "SelectOnClick", {"Selectable", "Clickable"})

function SelectOnClick:Clickable_onClickStart(button)
    if button == 1 then
        self.actor.Selectable:select()
    end
end

return SelectOnClick
