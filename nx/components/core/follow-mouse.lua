local FollowMouse = {}

registerComponent(FollowMouse, "FollowMouse")

function FollowMouse:setup(v, y)
    self.offset = Vector.new(v, y)
    self.cachedMousePos = Vector.new(love.mouse.getPosition())
end

function FollowMouse:awake()
    self.offset = Vector.new()
    self.actor:setPos(Vector.new(love.mouse.getPosition()))
end

function FollowMouse:update(dt)
    if self.cachedMousePos then
        self.actor:setPos(self.cachedMousePos - self.offset)
    end
end

function FollowMouse:onMouseMove(x, y, dx, dy)
    self.actor:setPos(Vector.new(x, y) - self.offset)
    self.cachedMousePos = Vector.new(x, y)
end

function FollowMouse:onMousePress(x, y, button, wasRelease)
    self.actor:setPos(Vector.new(x, y) - self.offset)
    self.cachedMousePos = Vector.new(x, y)
end

return FollowMouse
