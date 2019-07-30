local DestroyImmediately = {}

registerComponent(DestroyImmediately,'DestroyImmediately')

function DestroyImmediately:awake()
    self.actor:destroy()
end

return DestroyImmediately