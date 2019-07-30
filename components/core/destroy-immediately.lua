local DestroyImmediately = {}

registerComponent(DestroyImmediately,'DestroyImmediately')

function DestroyImmediately:update()
    self.actor:destroy()
end

return DestroyImmediately