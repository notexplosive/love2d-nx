local sceneLayers = require("nx/scene-layers")
local FrameFreezeMode = {}

registerComponent(FrameFreezeMode, "FrameFreezeMode")

function FrameFreezeMode:awake()
    local renderer = self.actor:addComponent(Components.GameSceneSecondsRenderer)
    self.actor:addComponent(Components.SidebarIcon, 1, renderer)

    for i, scene in sceneLayers:each() do
        local canBeFrameFrozen = scene:getFirstBehaviorIfExists(Components.SceneCanBeFrameFrozen)
        if canBeFrameFrozen then
            canBeFrameFrozen:freeze()
        end
    end
end

function FrameFreezeMode:onDestroy()
    for i, scene in sceneLayers:each() do
        local canBeFrameFrozen = scene:getFirstBehaviorIfExists(Components.SceneCanBeFrameFrozen)
        if canBeFrameFrozen then
            canBeFrameFrozen:unfreeze()
        end
    end
end

return FrameFreezeMode
