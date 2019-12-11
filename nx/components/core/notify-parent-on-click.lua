local NotifyParentOnClick = {}

registerComponent(NotifyParentOnClick, "NotifyParentOnClick", {"Parent", "Clickable"})

function NotifyParentOnClick:setup(message, button)
    self.message = message
    self.button = button or 1
end

function NotifyParentOnClick:Clickable_onClickOn(button)
    if self.button == button then
        self.actor.Parent:get():onNotify(self.message)
    end
end

return NotifyParentOnClick
