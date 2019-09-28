local SpawnMousePointer = {}

registerComponent(SpawnMousePointer,'SpawnMousePointer')

function SpawnMousePointer:awake()
    local actor = uiScene:addActor()

    actor:addComponent(Components.SpriteRenderer,'cursor')
    actor:addComponent(Components.FollowMouse, -16, -16)
    actor:addComponent(Components.MousePointer)

    self.child = actor
end

function SpawnMousePointer:onDestroy()
    self.child:destroy()
end

return SpawnMousePointer