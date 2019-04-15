local Actor = require("nx/game/actor")
local Vector = require("nx/vector")
local Scene = {}

function Scene.new(width, height)
    local self = newObject(Scene)
    self.hasStarted = false
    self.actors = {}
    self.originalActors = {}
    self.width = width
    self.height = height
    self.freeze = false
    self.camera = Vector.new(0, 0)

    -- Scene Shake
    self.shakeFrames = 0
    self.shakeVariance = 0

    if width == nil then
        self.width = love.graphics.getWidth()
        self.height = love.graphics.getHeight()
    end

    return self
end

-- Add actor to list
-- Generally you want to call this with a string to create a new actor.
-- Although you could remove an actor from a scene and re-add it, or add it to a different scene
function Scene:addActor(actor, ...)
    assert(actor ~= nil, "Scene:addActor must take at least one argument")
    if type(actor) == "string" then
        return self:addActor(Actor.new(actor))
    end

    assert(actor:type() == Actor, "Can't add a non-actor to a scene")

    if actor.parentScene == nil then
        actor.parentScene = self
    end

    --actor.scene = self
    if actor.originalScene == nil then
        actor.originalScene = self
        append(self.originalActors, actor)
    end

    actor._justAddedToScene = true
    append(self.actors, actor)

    if ... then
        for i, v in ipairs({...}) do
            self:addActor(v)
        end
    end

    return actor
end

-- Get actor by name
function Scene:getActor(actorName)
    assert(actorName)
    for i, actor in ipairs(self.actors) do
        if actor.name == actorName then
            return actor, i
        end
    end

    return nil
end

function Scene:getMousePosition()
    return (Vector.new(love.mouse.getPosition())):components()
end

-- Get index of actor in actor list
function Scene:getActorIndex(actor)
    assert(actor)
    for i, iactor in ipairs(self.actors) do
        if iactor == actor then
            return i
        end
    end

    return nil
end

function Scene:destroyAllActors()
    local actors = self:getAllActors()
    for i, v in ipairs(actors) do
        v:destroy()
    end
end

function Scene:getAllActors()
    return copyList(self.actors)
end

function Scene:getAllActorsWithBehavior(behavior)
    local result = {}
    local i = 1

    for j, actor in ipairs(self.actors) do
        if actor[behavior.name] then
            result[i] = actor
            i = i + 1
        end
    end

    return result
end

function Scene:getFirstActorWithBehavior(behavior)
    local result = {}

    for j, actor in ipairs(self.actors) do
        if actor[behavior.name] then
            return actor
        end
    end

    return nil
end

function Scene:getBounds()
    return 0, 0, self.width, self.height
end

function Scene:getDimensions()
    return self.width, self.height
end

-- TODO: move this out
function Scene:shake(frames, variance)
    self.shakeFrames = frames or 5
    self.shakeVariance = variance or 2
end

-- Creates an event with a list of strings representing the args for that event
function Scene:createEvent(functionName, args)
    assert(Scene[functionName] == nil, "Scene already has an event called " .. functionName)
    assert(Actor[functionName] == nil, "Actor already has an event called " .. functionName)
    print("Scene Event " .. "Scene:" .. functionName .. "(" .. string.join(args, ", ") .. ")")

    -- Actor Event
    -- Calls Scene Event on all actor components
    Actor:createEvent(functionName, args)

    -- Scene Event
    -- Call Scene Event on all actors
    Scene[functionName] = function(self, ...)
        assert(#{...} <= #args + 1, "Wrong number of arguments passed to Scene:" .. functionName)

        for i, actor in ipairs(self:getAllActors()) do
            actor[functionName](actor, ...)
        end
    end
end

-- Input Events
Scene:createEvent("onClick", {"x", "y", "button", "wasRelease"})
Scene:createEvent("onKeyPress", {"key", "scancode", "wasRelease"})
Scene:createEvent("onMouseMoved", {"x", "y", "dx", "dy"})
Scene:createEvent("onScroll", {"x", "y"})

-- Game Events: These are special events that need special behavior
function Scene:update(dt)
    -- Run any applicable start functions
    for i, actor in ipairs(self.actors) do
        if actor._justAddedToScene then
            actor._justAddedToScene = nil
            actor:start()
        end
    end

    for i, actor in ipairs(self.actors) do
        if not self.freeze then
            actor:update(dt)
        end
    end
end

function Scene:draw()
    local shake = Vector.new()
    if self.shakeFrames > 0 then
        shake.x = love.math.random(-self.shakeVariance, self.shakeVariance)
        shake.y = love.math.random(-self.shakeVariance, self.shakeVariance)
        self.shakeFrames = self.shakeFrames - 1
    end

    for i, actor in ipairs(self.actors) do
        if actor.visible then
            local x, y = actor.pos.x - self.camera.x + shake.x, actor.pos.y - self.camera.y + shake.y
            actor:draw(x, y)
        end
    end

    if self.lastDraw then
        self:lastDraw(x, y)
    end
end

return Scene
