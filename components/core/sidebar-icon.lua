local SidebarIcon = {}

registerComponent(SidebarIcon, "SidebarIcon")

function SidebarIcon:setup(index, renderer)
    self.index = index
    local center = Vector.new(love.graphics.getDimensions()) / 2

    local startPos = Vector.new(center.x * 2 + 64, self.index * 64)
    local endPos = Vector.new(center.x * 2 - 32 - 16, self.index * 64)
    self.actor:setPos(startPos)
    self.actor:addComponent(Components.EaseTo, endPos)

    self.renderer = renderer
    self.targetPosAfterDestroy = startPos:clone()
end

function SidebarIcon:onDestroy()
    local actor = self.actor:scene():addActor()
    actor:setPos(self.actor:pos())
    actor:addComponent(Components[self.renderer.name], self.renderer:reverseSetupSafe())
    actor:addComponent(Components.EaseTo,self.targetPosAfterDestroy)
    actor:addComponent(Components.EaseToDestroy)
end

return SidebarIcon
