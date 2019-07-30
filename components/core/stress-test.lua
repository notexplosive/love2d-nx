local StressTest = {}

registerComponent(StressTest,'StressTest')

function StressTest:awake()
    for i=1, 10000 do
        local actor = self.actor:scene():addActor()
        actor:addComponent(Components.DestroyAtRandomTime)
        actor:addComponent(Components.MoveByRandom)
        actor:addComponent(Components.SpriteRenderer):setup("linkin",'walk',2)
    end
end

function StressTest:update(dt)
    if 1/dt > 60 then
        debugLog(#self.actor:scene():getAllActors())
        self.actor:destroy()
    end
end

return StressTest