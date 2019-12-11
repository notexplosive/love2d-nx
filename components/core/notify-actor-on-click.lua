local NotifyActorOnClick = {}

registerComponent(NotifyActorOnClick, "NotifyActorOnClick", {"Clickable"})

function NotifyActorOnClick:setup(targetActor, message)
    self.targetActor = targetActor
    self.message = message
end

function NotifyActorOnClick:Clickable_onClickOn(button)
    if button == 1 then
        self.targetActor:onNotify(self.message)
    end
end

return NotifyActorOnClick
