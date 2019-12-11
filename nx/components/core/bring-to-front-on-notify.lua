local BringToFrontOnNotify = {}

registerComponent(BringToFrontOnNotify,'BringToFrontOnNotify')

function BringToFrontOnNotify:setup(msg)
    self.msg = msg
end

function BringToFrontOnNotify:start()
    assert(self.msg)
end

function BringToFrontOnNotify:onNotify(msg)
    if msg == self.msg then
        self.actor:scene():bringToFront(self.actor)
    end
end

return BringToFrontOnNotify