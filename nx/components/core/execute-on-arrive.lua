local ExecuteOnArrive = {}

registerComponent(ExecuteOnArrive, "ExecuteOnArrive", {"MoveTowards"})

function ExecuteOnArrive:setup(callback)
    self.callback = callback
end

function ExecuteOnArrive:MoveTowards_onArrive()
    self.callback()
end

return ExecuteOnArrive
