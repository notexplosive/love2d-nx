local EaseFromTo = {}

registerComponent(EaseFromTo,'EaseFromTo')

function EaseFromTo:setup(from,to)
    assert(from)
    assert(to)
    assert(from:type() == Vector)
    assert(to:type() == Vector)
    self.actor:setPos(from)
    self.actor:addComponentSafe(Components.EaseTo, to)
end

return EaseFromTo