local SidebarIcon = {}

registerComponent(SidebarIcon, "SidebarIcon")

function SidebarIcon:setup()
    index = #self.actor:scene():getAllActorsWith(Components.SidebarIcon)
    local center = Vector.new(love.graphics.getDimensions()) / 2

    local startPos = Vector.new(center.x * 2 + 64, index * 64)
    local endPos = Vector.new(center.x * 2 - 32 - 16, index * 64)
    self.actor:setPos(startPos)
    self.actor:addComponent(Components.EaseTo, endPos)

    self.targetPosAfterDestroy = startPos:clone()
end

function SidebarIcon:retract()
    self.actor:addComponentSafe(Components.EaseTo, self.targetPosAfterDestroy)
    self.actor:addComponent(Components.EaseToDestroy)
end

return SidebarIcon
