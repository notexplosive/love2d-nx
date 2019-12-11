local DestroyAfterOneFrame = {}

registerComponent(DestroyAfterOneFrame, "DestroyAfterOneFrame")

function DestroyAfterOneFrame:awake()
    self.frames = 0
end

function DestroyAfterOneFrame:update(dt)
    if self.frames > 0 then
        self.actor:destroy()
    end
    self.frames = self.frames + 1
end

return DestroyAfterOneFrame
