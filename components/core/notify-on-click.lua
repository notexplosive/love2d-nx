local NotifyOnClick = {}

-- This is the base "Button"
-- Also can be used for checkbox and various other things

registerComponent(NotifyOnClick, "NotifyOnClick", {"BoundingBox", "Clickable"})

function NotifyOnClick:setup(message, button)
    self.message = message
    self.button = button or 1
end

function NotifyOnClick:Clickable_onClickOn(button)
    if self.button == button then
        self.actor:scene():onNotify(self.message)
    end
end

return NotifyOnClick
