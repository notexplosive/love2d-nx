local AlwaysOnTop = {}

registerComponent(AlwaysOnTop,'AlwaysOnTop')

function AlwaysOnTop:update(dt)
    self.actor:scene():bringToFront(self.actor)
end

return AlwaysOnTop