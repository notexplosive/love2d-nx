local Sound = {}

-- TODO: currently when a new scene is loaded, any copied sound source set to loop will keep looping
-- This is a problem for multiplexed loops, which don't come up very often.

-- Called by templating code, should never be called directly.
function Sound.new(filename,volume)
    local self = newObject(Sound)

    self.source = love.audio.newSource(filename, 'static')
    self.source:setVolume(volume or 1)
    self.source:setPitch(pitch or 1)

    return self
end

function Sound:play(multiplex)
    if multiplex then
        self.source:clone():play()
    end

    self.source:play()
end

function Sound:stop()
    self.source:stop()
end

function Sound:get()
    return self.source:clone()
end

function Sound:stopThenPlay()
    self:stop()
    self:play()
end

return Sound