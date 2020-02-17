local World = {}

registerComponent(World, "World")

function World:awake()
    love.physics.setMeter(64) --the height of a meter our worlds will be 64px
    self.world = love.physics.newWorld(0, 9.81 * 64, true) --create a world for the bodies to exist in with horizontal gravity of 0 and vertical gravity of 9.81
end

function World:update(dt)
    self.world:update(dt)
end

function World:__call()
    return self.world
end

return World
