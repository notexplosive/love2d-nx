local AffixPos = {}

registerComponent(AffixPos,'AffixPos')

function AffixPos:setup(name,v,y)
    self.target = self.actor:scene():getActor(name)
    self.offset = Vector.new(v,y)
    assert(self.target,"AffixPos was given a target that does not exist")
end

function AffixPos:start()
    assert(self.target,"AffixPos was not initialized with a target")
end

function AffixPos:update(dt)
    self.actor:setPos(self.target:pos() + self.offset)
end

function AffixPos:affixTo(actor,v,y)
    self.target = actor
    self.offset = Vector.new(v,y)
end

return AffixPos