local ParticleSystem = {}

registerComponent(ParticleSystem, "ParticleSystem")

function ParticleSystem:setup(imageName, buffer)
    local image = love.graphics.newImage("assets/images/" .. imageName)
    self.particleSystem = love.graphics.newParticleSystem(image, buffer or 100)
    self.particleSystem:setParticleLifetime(1, 2) -- Particles live at least 2s and at most 5s.
    self.particleSystem:setEmissionRate(50)
    self.particleSystem:setSizeVariation(1)
    self.particleSystem:setLinearAcceleration(-100, -100, 100, 100) -- Random movement in all directions.
    self.particleSystem:setColors(0, 0, 0, 0.5)
end

function ParticleSystem:draw(x, y)
    love.graphics.draw(self.particleSystem, x, y)
end

function ParticleSystem:update(dt)
    self.particleSystem:update(dt)
end

return ParticleSystem
