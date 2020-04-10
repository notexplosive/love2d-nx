local MoveByRandom = {}

registerComponent(MoveByRandom, "MoveByRandom")

function MoveByRandom:awake()
end

function MoveByRandom:draw(x, y)
end

function MoveByRandom:update(dt)
    self.actor:setPos(self.actor:pos() + Vector.new(math.random(1, 3), math.random(1, 3)))
end

return MoveByRandom
