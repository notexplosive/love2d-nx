local SelectOnMouseDown = {}

registerComponent(SelectOnMouseDown,'SelectOnMouseDown', {"Selectable","Clickable"})

function SelectOnMouseDown:Clickable_onClickStart(button)
    if button == 1 then
        self.actor.Selectable:select()
    end
end

return SelectOnMouseDown