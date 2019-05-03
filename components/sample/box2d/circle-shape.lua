local CircleShape = {}

registerComponent(CircleShape,'CircleShape',{'Body'})

function CircleShape:setup(radius)
    assert(radius, "CircleShape needs a radius")
    self.shape = love.physics.newCircleShape(radius)
end

function CircleShape:awake()
    self.shape = love.physics.newCircleShape(20)
end

function CircleShape:draw(x,y)
    love.graphics.setColor(0.5,0.5,1)
    love.graphics.circle('line',x,y,self.shape:getRadius())
end

function CircleShape:update(dt)
    
end

return CircleShape