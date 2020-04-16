local SpawnMousePointer = {}

registerComponent(SpawnMousePointer, "SpawnMousePointer")

function SpawnMousePointer:awake()
    local actor = self.actor:scene():addActor()

    actor:addComponent(Components.MousePointer)

    self.child = actor
end

function SpawnMousePointer:onDestroy()
    self.child:destroy()
end

return SpawnMousePointer
