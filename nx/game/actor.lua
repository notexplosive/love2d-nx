-- You should only need to require this file if you're actually assembling an actor yourself
-- 99% of the time you can juse use:
--  `local actor = scene:addActor("actorName")`

local Actor = {}

function Actor.new(name)
    assert(name ~= nil, "Must provide a name for actor")
    local self = newObject(Actor)
    self.name = name
    self.components = {}
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

    -- TODO: remove "Components.", just "ActorData"
    -- ActorData needs to be moved to nx/game/components
    self:addComponent(Components.ActorData)

    return self
end

-- called by scene OR by others
function Actor:destroy()
    if self.isDestroyed then return end
    self.isDestroyed = true
    self:onDestroy()

    -- Needs to be cached before the loop because the loop mutates self.children
    local children = copyList(self.children or {})
    for i, child in ipairs(children) do
        child:destroy()
    end

    self.isDestroyed = true
    self:removeFromScene()
end

-- Deletes actor from scene without calling onDestroy
function Actor:removeFromScene()
    if self:scene() then
        local index = self:scene():getActorIndex(self)
        for i = index, #self:scene().actors do
            self:scene().actors[i] = self:scene().actors[i + 1]
        end
        self.originalScene = nil
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

function Actor:addComponent(componentClass)
    assert(componentClass, "Actor:addComponent() was passed nil")
    assert(componentClass.name, "Component needs a name")
    assert(self[componentClass.name] == nil, "Actor already has a " .. componentClass.name .. " component")

    local component = componentClass.create_object()

    for i, dep in ipairs(componentClass.dependencies) do
        assert(self[dep], componentClass.name .. " depends on " .. dep .. ", must :addComponent(" .. dep .. ")")
    end

    component.actor = self

    self[component.name] = component

    append(self.components, component)

    if component.awake then
        component:awake()
    end

    return component
end

function Actor:removeComponent(componentClass)
    assert(componentClass, "Actor:removeComponent() was passed nil")
    assert(componentClass.name, "Component needs a name")
    assert(self[componentClass.name], "Actor does not have a " .. componentClass.name .. " component")
    deleteFromList(self.components, self[componentClass.name])
    self[componentClass.name] = nil
end

function Actor:addComponentSafe(componentClass)
    if not self[componentClass.name] then
        return self:addComponent(componentClass)
    end
    return self[componentClass.name]
end

function Actor:removeComponentSafe(componentClass)
    if self[componentClass.name] then
        self:removeComponent(componentClass)
    end
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

function Actor:getChildByName(name)
    for i, actor in ipairs(self.children or {}) do
        if actor.name == name then
            return actor
        end
    end
    return nil
end

function Actor:createEvent(functionName, args)
    assert(self[functionName] == nil, "Actor already has an event called " .. functionName)
    args = args or {}

    print("Actor Event " .. "Actor:" .. functionName .. "(" .. string.join(args, ", ") .. ")")

    self[functionName] = function(self, ...)
        assert(#{...} <= #args + 1, "Wrong number of arguments passed to Actor:" .. functionName)
        for i, component in ipairs(self.components) do
            if component[functionName] then
                -- gale hack, nx doesn't have a concept of "editMode" yet
                if (not gameScene.editMode or (gameScene.editMode and not component.disableInEditMode)) then
                    -- /gale hack
                    component[functionName](component, ...)
                end
            end
        end
    end
end

-- Called by Scene
Actor:createEvent("update", {"dt"})
Actor:createEvent("draw", {"x", "y"})
Actor:createEvent("start")
Actor:createEvent("onDestroy")
Actor:createEvent("onMousePress", {"x", "y", "button", "wasRelease", "isClickConsumed"})

function Actor:isCenterOutOfBounds()
    if self.scene then
        return not isWithinRect(self:pos().x, self:pos().y, self:scene():getBounds())
    end

    print(self.actor.name .. " bounds check not applicable, no scene")
    return nil
end

-- Calls method on all components that have this method
function Actor:callForAllComponents(methodName, ...)
    for i, component in ipairs(self.components) do
        if component[methodName] then
            component[methodName](component, ...)
        end
    end
end

function Actor:duplicate()
    assert(self.ActorData, "cannot duplicate an actor with no ActorData component")
    if self.ActorData:isPrefab() then
        return loadActorData(self:scene(), self.ActorData:getData(), self.ActorData:getPrefabData())
    else
        return loadActorData(self:scene(), self.ActorData:getData())
    end
end

return Actor
