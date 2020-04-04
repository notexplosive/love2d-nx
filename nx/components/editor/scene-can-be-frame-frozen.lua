local FrameFreezeListener = {}

registerComponent(FrameFreezeListener, "FrameFreezeListener")

function FrameFreezeListener:setup(boolean)
    if boolean == false then
        self:destroy()
    end
end

function FrameFreezeListener:freeze()
    self.actor:scene().freeze = true
end

function FrameFreezeListener:unfreeze()
    self.actor:scene().freeze = false
end

function FrameFreezeListener:tick(seconds)
    if self.actor:scene().freeze then
        self.actor:scene().freeze = false
        self.actor:scene():update(seconds)
        self.actor:scene().freeze = true
    end
end

return FrameFreezeListener
