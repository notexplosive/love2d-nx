local AffixPos = {}

registerComponent(AffixPos,'AffixPos')

function AffixPos:setup(nameOrActor,v,y)
    local name = nil
    if type(nameOrActor) == 'string' then
        name = nameOrActor
        self.target = self.actor:scene():getActor(name)
    else
        self.target = nameOrActor
    end

    self.offset = Vector.new(v,y)
    self:affix()
    assert(self.target,"AffixPos was given a target that does not exist")
end

function AffixPos:start()
    assert(self.target,"AffixPos was not initialized with a target")
end

function AffixPos:update(dt)
    self:affix()
end

function AffixPos:affix()
    self.actor:setPos(self.target:pos() + self.offset)
end

function AffixPos:affixTo(actor,v,y)
    self.target = actor
    self.offset = Vector.new(v,y)
end

return AffixPos