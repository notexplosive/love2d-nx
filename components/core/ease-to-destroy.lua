local EaseToDestroy = {}

registerComponent(EaseToDestroy,'EaseToDestroy')

function EaseToDestroy:update(dt)
    if not self.actor.EaseTo then
        self.actor:destroy()
    end
end

return EaseToDestroy