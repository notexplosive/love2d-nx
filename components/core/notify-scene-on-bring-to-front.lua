local NotifySceneOnBringToFront = {}

registerComponent(NotifySceneOnBringToFront,'NotifySceneOnBringToFront')

function NotifySceneOnBringToFront:setup(msg)
    self.msg = msg
end

function NotifySceneOnBringToFront:start()
    assert(self.msg)
end

function NotifySceneOnBringToFront:onBringToFront()
    self.actor:scene():onNotify(self.msg)
end

return NotifySceneOnBringToFront