local sceneLayers = require("nx/scene-layers")
local FrameFreezeMode = {}

registerComponent(FrameFreezeMode, "FrameFreezeMode")

function FrameFreezeMode:awake()
    self.time = 0
    self.stepSize = 1 / 60

    self.actor:addComponent(Components.SecondsRenderer)
    self.actor:addComponent(Components.SidebarIcon)

    for i, scene in sceneLayers:each() do
        local listener = scene:getFirstBehaviorIfExists(Components.FrameFreezeListener)
        if listener then
            listener:freeze()
        end
    end
end

function FrameFreezeMode:onDestroy()
    for i, scene in sceneLayers:each() do
        local listener = scene:getFirstBehaviorIfExists(Components.FrameFreezeListener)
        if listener then
            listener:unfreeze()
        end
    end

    self.actor.SidebarIcon:retract()
end

function FrameFreezeMode:onScroll(x, y)
    if y < 0 then
        for i, scene in sceneLayers:each() do
            local listener = scene:getFirstBehaviorIfExists(Components.FrameFreezeListener)
            if listener then
                listener:tick(self.stepSize)
            end
        end

        self.time = self.time + self.stepSize
        self.actor.SecondsRenderer:setTime(self.time) -- this is wrong
    end
end

return FrameFreezeMode
