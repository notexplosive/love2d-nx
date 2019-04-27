local RotateTowards = {}

registerComponent(RotateTowards,'RotateTowards')

function RotateTowards:setup(actor)
    self.target = actor
end

function RotateTowards:awake()
    self.target = nil
end

function RotateTowards:draw(x,y)
    love.graphics.circle('line',x,y,20)
    local vec = Vector.new(1,0) * 50
    vec:setAngle(self.actor:angle())
    love.graphics.line(x,y,x-vec.x,y-vec.y)
end

function RotateTowards:update(dt)
    local diff = self.actor:pos() - self.target:pos()
    self.actor:setAngle(diff:angle())
end

return RotateTowards