local EditorSerializable = {}

registerComponent(EditorSerializable,'EditorSerializable')

function EditorSerializable:setup(component)
    self.component = component
end

function EditorSerializable:reverseSetup()
    return self.component
end

function EditorSerializable:start()
    assert(self.component, "setup not run")
end

function EditorSerializable:getArgs()
    return self.component:reverseSetup()
end

function EditorSerializable:getComponentClass()
    return Components[self.component.name]
end

function EditorSerializable:getAngle()
    if self.actor.DoNotSerializeAngle then
        return 0
    end
    
    return radianToDegree(self.actor:angle())
end

local Test = require("nx/test")
Test.registerComponentTest(
    EditorSerializable,
    function()
        local Actor = require("nx/game/actor")
        local setupArgs = {}
        local actor = Actor.new()
        local subject = actor:addComponent(EditorSerializable,unpack(setupArgs))
    end
)

return EditorSerializable