local FrameFreezeMode = {}

registerComponent(FrameFreezeMode, "FrameFreezeMode")

function FrameFreezeMode:awake()
    self.actor:addComponent(Components.FrameStep)
    local renderer = self.actor:addComponent(Components.GameSceneSecondsRenderer)
    self.actor:addComponent(Components.SidebarIcon, 1, renderer)
    gameScene.freeze = true
end

function FrameFreezeMode:onDestroy()
    gameScene.freeze = false
end

return FrameFreezeMode
