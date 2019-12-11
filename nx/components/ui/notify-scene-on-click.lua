local NotifySceneOnClick = {}

-- This is the base "Button"
-- Also can be used for checkbox and various other things

registerComponent(NotifySceneOnClick, "NotifySceneOnClick", {"BoundingBox", "Clickable"})

function NotifySceneOnClick:setup(message, button)
    self.message = message
    self.button = button or 1
end

function NotifySceneOnClick:Clickable_onClickOn(button)
    if self.button == button then
        self.actor:scene():onNotify(self.message)
    end
end

return NotifySceneOnClick
