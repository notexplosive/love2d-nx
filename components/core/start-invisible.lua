local StartInvisible = {}

registerComponent(StartInvisible,'StartInvisible')

function StartInvisible:awake()
    self.actor.visible = false
end

return StartInvisible