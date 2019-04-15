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
    self.boundingWidth = 32
    self.boundingHeight = 32
    self.boundingOffset = Vector.new(0, 0)
    self.visible = true
    self.useCustomBoundingBox = false

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
    assert(Actor[functionName] == nil, "Actor already has an event called " .. functionName)
    args = args or {}

    print("Actor Event " .. 'Actor:' .. functionName .. "(" .. string.join(args,', ') .. ')' )

    Actor[functionName] = function(self, ...)
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

-- Called by Colliders, TODO: move this into BoundingBox component
Actor:createEvent("onCollide", {"otherActor"})

-- TODO: move all of this to new component
function Actor:getBoundingBox()
    if
        self.spriteRenderer and (self.boundingOffset.x == 0 or self.boundingOffset.y == 0) and
            not self.useCustomBoundingBox
     then
        return self.spriteRenderer:getBoundingBox()
    end
    return self.pos.x - self.boundingOffset.x, self.pos.y - self.boundingOffset.y, self.boundingWidth, self.boundingHeight
end

function Actor:setBoundingBoxDimensions(w, h)
    self.boundingWidth = w
    self.boundingHeight = h
end

function Actor:isWithinBoundingBox(x, y)
    return isWithinBox(x, y, self:getBoundingBox())
end

function Actor:isCenterOutOfBounds()
    if self.scene then
        return not isWithinBox(self.pos.x, self.pos.y, self:scene():getBounds())
    end

    print(self.actor.name .. " bounds check not applicable, no scene")
    return nil
end

function Actor:isOutOfBounds()
    if self.scene then
        local x, y, w, h = self:getBoundingBox()
        local x2, y2 = x + w, y + h
        return not isWithinBox(x, y, self:scene():getBounds()) and not isWithinBox(x, y2, self:scene():getBounds()) and
            not isWithinBox(x2, y, self:scene():getBounds()) and
            not isWithinBox(x2, y2, self:scene():getBounds())
    end

    print(self.actor.name .. " bounds check not applicable, no scene")
end

return Actor
