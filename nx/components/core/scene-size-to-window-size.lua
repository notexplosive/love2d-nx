local SceneSizeToWindowSize = {}

registerComponent(SceneSizeToWindowSize, "SceneSizeToWindowSize")

function SceneSizeToWindowSize:setup(bottomBuffer)
    -- fenestra hack
    self.bottomBuffer = bottomBuffer
    -- /fenestra hack
end

function SceneSizeToWindowSize:update(dt)
    local w, h = love.graphics.getDimensions()
    self.actor:scene():setDimensions(w, h - (self.bottomBuffer or 0))
end

return SceneSizeToWindowSize
