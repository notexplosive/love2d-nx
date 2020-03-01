local World = {}

registerComponent(World, "World")

function World:awake()
    love.physics.setMeter(64) --the height of a meter our worlds will be 64px
    self.world = love.physics.newWorld(0, 0, true)
end

function World:update(dt)
    self.world:update(dt)
end

function World:__call()
    return self.world
end

return World
