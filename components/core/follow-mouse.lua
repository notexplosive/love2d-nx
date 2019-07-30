local FollowMouse = {}

registerComponent(FollowMouse, "FollowMouse")

function FollowMouse:setup(v,y)
    self.offset = Vector.new(v,y)
end

function FollowMouse:awake()
    self.offset = Vector.new()
    self.actor:setPos(Vector.new(love.mouse.getPosition()))
end

function FollowMouse:onMouseMove(x, y, dx, dy)
    self.actor:setPos(Vector.new(x, y) - self.offset)
end

function FollowMouse:onMousePress(x, y, button, wasRelease)
    self.actor:setPos(Vector.new(x, y) - self.offset)
end

return FollowMouse
