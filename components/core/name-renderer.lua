local NameRenderer = {}

registerComponent(NameRenderer,'NameRenderer')

function NameRenderer:awake()
    
end

function NameRenderer:draw(x,y)
    love.graphics.setColor(1,1,1,1)
    love.graphics.print(self.actor.name,x,y)
end

function NameRenderer:update(dt)
    
end

return NameRenderer