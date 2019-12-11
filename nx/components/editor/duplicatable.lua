local Duplicatable = {}

registerComponent(Duplicatable, "Duplicatable", {"Selectable", "Keybind"})

function Duplicatable:setup(keybind)
    self.keybind = keybind
end

function Duplicatable:reverseSetup()
    return self.keybind
end

function Duplicatable:start()
    assert(self.keybind)
end

function Duplicatable:Keybind_onPress(key)
    if key == self.keybind and self.actor.Selectable:selected() and self:canDuplicate() then
        local newActor = self.actor:scene():addActor()
        newActor:setPos(self.actor:pos() + Vector.new(20,20))
        newActor:setAngle(self.actor:angle())
        newActor:addComponent(self.actor.EditorSerializable:getComponentClass(),self.actor.EditorSerializable:getArgs())
        newActor:addComponent(Components.SelectWhenAble)
    end
end

function Duplicatable:canDuplicate()
    return self.actor.EditorSerializable ~= nil
end

return Duplicatable
