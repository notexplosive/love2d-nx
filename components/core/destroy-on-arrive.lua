local DestroyOnArrive = {}

registerComponent(DestroyOnArrive, "DestroyOnArrive", {"MoveTowards"})

function DestroyOnArrive:MoveTowards_onArrive()
    self.actor:destroy()
end

return DestroyOnArrive
