local SidebarIcon = {}

registerComponent(SidebarIcon, "SidebarIcon")

function SidebarIcon:setup(index)
    self.index = index
    local center = Vector.new(love.graphics.getDimensions()) / 2

    local startPos = Vector.new(center.x * 2 + 64, self.index * 64)
    local endPos = Vector.new(center.x * 2 - 32 - 16, self.index * 64)
    self.actor:setPos(startPos)
    self.actor:addComponent(Components.EaseTo, endPos)

    self.targetPosAfterDestroy = startPos:clone()
end

function SidebarIcon:retract()
    self.actor:addComponentSafe(Components.EaseTo, self.targetPosAfterDestroy)
    self.actor:addComponent(Components.EaseToDestroy)
end

return SidebarIcon
