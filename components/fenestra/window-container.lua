local WindowContainer = {}

registerComponent(WindowContainer,'WindowContainer')

function WindowContainer:setup(actor)
    self:addChild(actor)
end

function WindowContainer:addChild(actor)
    actor:addComponent(Components.AffixPos,self.actor)
end

return WindowContainer