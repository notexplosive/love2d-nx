local MoveRandom = {}

registerComponent(MoveRandom, "MoveRandom")

function MoveRandom:awake()
end

function MoveRandom:draw(x, y)
end

function MoveRandom:update(dt)
    self.actor:move(Vector.new(love.math.random(-2, 2), love.math.random(-2, 2)))
end

return MoveRandom
