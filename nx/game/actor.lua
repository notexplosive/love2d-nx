-- You should only need to require this file if you're actually assembling an actor yourself
-- 99% of the time you can juse use:
--  `local actor = scene:addActor("actorName")`

local Actor = {}

function Actor.new(name, star)
    assert(name ~= nil, "Must provide a name for actor")
    local self = newObject(Actor)
    self.name = name
    self.pos = Vector.new()
    self.angle = 0
    self.components = {}
    self.visible = true

    function self:scene()
        assert(self, "use Actor:scene() and not Actor.scene()")
        return self.originalScene
    end
    -- Used for lens logic
    self.originalScene = nil
    -- The scene that summoned this actor
    self.parentScene = nil
    self.star = star or false

    return self
end

-- called by scene OR by others
function Actor:destroy()
    self:onDestroy()
    self:removeFromScene()
end

-- Deletes actor from scene without calling onDestroy
function Actor:removeFromScene()
    if self:scene() then
        local index = self:scene():getActorIndex(self)
        self:scene().actors[index] = nx_null
        for i = index, #self:scene().actors do
            self:scene().actors[i] = self:scene().actors[i + 1]
        end
        self.originalScene = nil
    end
end

function Actor:addComponent(componentClass)
    assert(componentClass, "Actor:addComponent() was passed nil")
    assert(componentClass.name, "Component needs a name")
    local component = componentClass.create()
    component.actor = self

    self[component.name] = component

    append(self.components, component)

    if component.awake then
        component:awake()
    end

    return component
end

function Actor:move(velocity)
    assert(velocity:type() == Vector)
    self.pos = self.pos + velocity
end

function Actor:setPosition(pos)
    self.pos = pos:clone()
end

function Actor:createEvent(functionName, args)
    assert(self[functionName] == nil, "Actor already has an event called " .. functionName)
    args = args or {}

    print("Actor Event " .. 'Actor:' .. functionName .. "(" .. string.join(args,', ') .. ')' )

    self[functionName] = function(self, ...)
        assert(#{...} <= #args + 1, "Wrong number of arguments passed to Actor:" .. functionName)
        for i, component in ipairs(self.components) do
            if component[functionName] then
                component[functionName](component, ...)
            end
        end
    end
end

-- Called by Scene
Actor:createEvent("update", {"dt"})
Actor:createEvent("draw", {"x", "y"})
Actor:createEvent("start")


function Actor:isCenterOutOfBounds()
    if self.scene then
        return not isWithinBox(self.pos.x, self.pos.y, self:scene():getBounds())
    end

    print(self.actor.name .. " bounds check not applicable, no scene")
    return nil
end

return Actor
