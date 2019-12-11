local StressTest = {}

registerComponent(StressTest, "StressTest")

function StressTest:awake()
    for i = 1, 3000 do
        local actor = self.actor:scene():addActor()
        actor:addComponent(Components.DestroyAtRandomTime)
        actor:addComponent(Components.MoveByRandom)
        actor:addComponent(Components.MouseSelectable)
        actor:addComponent(Components.SpriteRenderer, "linkin", "walk", 2)
    end
end

function StressTest:update(dt)
    if 1 / dt > 60 then
        debugLog(#self.actor:scene():getAllActors())
        self.actor:destroy()
    end
end

return StressTest
