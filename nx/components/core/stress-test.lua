local StressTest = {}

registerComponent(StressTest, "StressTest")

function StressTest:awake()
    for i = 1, 3000 do
        self:spawn(0, 0)
    end
end

function StressTest:spawn(x, y)
    local actor = self.actor:scene():addActor()
    actor:setPos(x, y)
    actor:addComponent(Components.DestroyAtRandomTime)
    actor:addComponent(Components.MoveByRandom)
    actor:addComponent(Components.MouseSelectable)
    actor:addComponent(Components.SpriteRenderer, "linkin", "walk", 2)
end

function StressTest:onMousePress(x, y, button, wasRelease)
    if not wasRelease and button == 1 then
        for i = 1, 40 do
            self:spawn(x, y)
        end
    end
end

function StressTest:update(dt)
    if 1 / dt > 60 then
    --debugLog(#self.actor:scene():getAllActors())
    end
end

-- Tests
local Test = require("nx/test")
Test.registerComponentTest(
    StressTest,
    function()
        local Scene = require("nx/game/scene")
        local Actor = require("nx/game/actor")
        local actor = Scene.new():addActor("testActor")
        local subject = actor:addComponent(StressTest)
    end
)

return StressTest
