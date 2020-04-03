-- You should only need to require this file if you're actually assembling an actor yourself
-- 99% of the time you can juse use:
--  `local actor = scene:addActor("actorName")`
local DataLoader = require("nx/template-loader/data-loader")
local Actor = {}

function Actor.new(name)
    if not name then
        name = "<nameless actor>"
    end
    assert(name ~= Actor, "Do not use Actor:new(), use Actor.new()")
    assert(type(name) == "string", "name must be a string")
    local self = newObject(Actor)
    self.name = name
    self.components = List.new()
    self.visible = true

    -- Private
    self._localPos = Vector.new()
    self._angle = 0

    function self:scene()
        assert(self, "use Actor:scene() and not Actor.scene()")
        --assert(self.originalScene, "Cannot use Actor:scene(), scene is nil")
        return self.originalScene
    end

    self.originalScene = nil

    return self
end

function Actor:loadActorData(...)
    return DataLoader.loadActorData(...)
end

-- called by scene OR by others
function Actor:destroy()
    if self.isDestroyed then
        return
    end
    self.isDestroyed = true
    self:onDestroy()
end

-- Deletes actor from scene without calling onDestroy
function Actor:removeFromScene()
    if self:scene() then
        deleteFromList(self:scene().actors, self)
    end
end

function Actor:localPos()
    return self._localPos:clone()
end

function Actor:pos()
    return self._localPos:clone()
end

function Actor:angle()
    return self._angle
end

function Actor:setAngle(angle)
    assert(tonumber(angle), "Actor:setAngle takes a number")
    self._angle = angle
end

-- takes a vector or x,y
function Actor:setPos(v, y)
    assert(v, "setPos was given no arguments")
    -- Handle (x,y) case
    if tonumber(v) then
        local x = v
        v = Vector.new(x, y)
    end

    self._localPos = v
end

-- takes a vector or x,y
function Actor:setLocalPos(v, y)
    -- Handle (x,y) case
    if tonumber(v) then
        local x = v
        v = Vector.new(x, y)
    end

    self._localPos = v:clone()
end

function Actor:addComponent(componentClass, ...)
    assert(componentClass, "Actor:addComponent() was passed nil")
    assert(componentClass.name, "Component needs a name")
    assert(self[componentClass.name] == nil, "Actor already has a " .. componentClass.name .. " component")

    local component = componentClass.create_object()

    for i, dep in ipairs(componentClass.dependencies) do
        assert(
            self[dep],
            self.name .. " " .. componentClass.name .. " depends on " .. dep .. ", must :addComponent(" .. dep .. ")"
        )
    end

    component.actor = self

    self[component.name] = component

    self.components:add(component)

    if component.start then
        component._hasNotRunStart = true
    end

    if component.awake then
        component:awake()
    end

    if ... ~= nil then
        assert(component.setup, component.name .. " has no setup()")
    end

    if component.setup then
        component:setup(...)
    end

    return component
end

function Actor:removeComponent(componentClass)
    assert(componentClass, "Actor:removeComponent() was passed nil")
    assert(componentClass.name, "Component needs a name")
    local component = self[componentClass.name]
    assert(component, "Actor does not have a " .. componentClass.name .. " component")
    if component.onDestroy then
        component:onDestroy()
    end

    assert(self.components:removeElement(component) ~= nil, "Removed a component that never existed(?!)")

    self[componentClass.name] = nil

    return componentClass
end

function Actor:addComponentSafe(componentClass, ...)
    if not self[componentClass.name] then
        return self:addComponent(componentClass, ...)
    else
        if self[componentClass.name].setup and ... then
            self[componentClass.name]:setup(...)
        end
    end
    return self[componentClass.name]
end

function Actor:removeComponentSafe(componentClass)
    if self[componentClass.name] then
        self:removeComponent(componentClass)
        return componentClass
    end

    return nil
end

-- Takes vector or (x,y)
function Actor:move(displacement, y)
    if tonumber(displacement) then
        local x = displacement
        displacement = Vector.new(x, y)
    end

    assert(displacement:type() == Vector)
    self._localPos = self._localPos + displacement
end

function Actor:createEvent(methodName, args)
    assert(self[methodName] == nil, "Actor already has an event called " .. methodName)
    args = args or {}

    print("Actor Event " .. "Actor:" .. methodName .. "(" .. string.join(args, ", ") .. ")")

    self[methodName] = function(self, ...)
        --assert(#{...} <= #args + 1, "Wrong number of arguments passed to Actor:" .. methodName)
        self:callForAllComponents(methodName, ...)
    end
end

-- Called by Scene
-- Events are propagated down to each component
Actor:createEvent("update", {"dt"})
Actor:createEvent("start")
Actor:createEvent("draw", {"x", "y"})
Actor:createEvent("onDestroy")
Actor:createEvent("onMousePress", {"x", "y", "button", "wasRelease", "isClickConsumed"})
Actor:createEvent("onMouseMove", {"x", "y", "dx", "dy", "isHoverConsumed"})
Actor:createEvent("onBringToFront")
Actor:createEvent("onSendToBack")

-- Calls method on all components that have this method
function Actor:callForAllComponents(methodName, ...)
    local components = self.components:clone()
    for i, component in components:each() do
        if component[methodName] and not component._isDestroyed then
            component[methodName](component, ...)
        end
    end
end

function Actor:clone()
    local clone = nil
    if self:scene() then
        clone = self:scene():addActor()
    else
        clone = Actor.new()
    end

    clone:setPos(self:pos())
    clone:setAngle(self:angle())

    clone.name = self.name .. " clone"

    for i, component in self.components:each() do
        local componentClass = Components[component.name]
        assert(componentClass, component.name .. " class does not exist")
        clone:addComponentSafe(componentClass, component:reverseSetupSafe())
    end

    return clone
end

return Actor
