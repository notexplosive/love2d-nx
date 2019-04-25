local BouncingBall = {}

registerComponent(BouncingBall,'BouncingBall')

function BouncingBall:awake()
    local rx,ry = love.math.random(-10,10),love.math.random(-10,10)
    self.vel = Vector.new(rx,ry)
end

function BouncingBall:draw(x,y)
    love.graphics.circle('fill',x,y,20)
end

function BouncingBall:update(dt)
    self.actor:move(self.vel)
    
    if self.actor:pos().x < 0 then
        self.vel.x = math.abs(self.vel.x)
    end

    if self.actor:pos().x > self.actor:scene().width then
        self.vel.x = -math.abs(self.vel.x)
    end
    
    if self.actor:pos().y < 0 then
        self.vel.y = math.abs(self.vel.y)
    end

    if self.actor:pos().y > self.actor:scene().height then
        self.vel.y = -math.abs(self.vel.y)
    end
end

return BouncingBall