local RotateTowardsMouse = {}

registerComponent(RotateTowardsMouse,'RotateTowardsMouse')

function RotateTowardsMouse:setup(...)
    self.actor.RotateTowardsPoint:setup(...)
end

function RotateTowardsMouse:awake()
    self.actor:addComponent(Components.RotateTowardsPoint)
end

function RotateTowardsMouse:onMouseMove(x,y,dx,dy)
    self.actor.RotateTowardsPoint.target = Vector.new(x,y)
end

return RotateTowardsMouse