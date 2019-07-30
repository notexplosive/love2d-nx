local PrefabDataRenderer = {}

registerComponent(PrefabDataRenderer,'PrefabDataRenderer')

local font = love.graphics.newFont(16)

function PrefabDataRenderer:draw(x,y)
    love.graphics.setFont(font)
    love.graphics.setColor(0,0.5,1)
    if self.actor.BoundingBox then
        local x,y = self.actor.BoundingBox:getRect()
        love.graphics.print(self.actor.ActorData.prefabTemplateName,math.floor(x),math.floor(y-love.graphics.getFont():getHeight()))
    end
end

return PrefabDataRenderer