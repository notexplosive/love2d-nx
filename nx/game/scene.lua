local Actor = require("nx/game/actor")
local Vector = require("nx/vector")
local DataLoader = require("nx/template-loader/data-loader")
local Scene = {}

function Scene.new(width, height)
    local self = newObject(Scene)
    self.hasStarted = false
    self.actors = {}
    self:setDimensions(width, height)
    self.freeze = false
    self.camera = Vector.new(0, 0)
    self.world = love.physics.newWorld(0, 9.8, true)
    self.isClickConsumed = false

    -- Scene Shake
    self.shakeFrames = 0
    self.shakeVariance = 0

    if width == nil then
        self:setDimensions(love.graphics.getDimensions())
    end

    self.editMode = false

    return self
end

function Scene:setDimensions(width, height)
    self.width = width
    self.height = height
end

-- Add actor to list
-- Generally you want to call this with a string to create a new actor.
-- Although you could remove an actor from a scene and re-add it, or add it to a different scene
function Scene:addActor(actor)
    if actor == nil then
        actor = Actor.new("ACTOR" .. math.random(1000))
    end

    if type(actor) == "string" then
        return self:addActor(Actor.new(actor))
    end

    assert(actor:type() == Actor, "Can't add a non-actor to a scene")

    actor.originalScene = self
    actor._justAddedToScene = true

    append(self.actors, actor)

    return actor
end

function Scene:addPrefab(prefabName,...)
    -- Dehydrate the actor to a prefab node
    local nodeData = {
        prefab = prefabName,
        arguments = {...}
    }

    local actor = DataLoader.loadPrefabData(self, nodeData)

    return actor
end

function Scene.fromSceneData(sceneData)
    local scene = Scene.new()
    
    if sceneData.dimensions then
        assert(#sceneData.dimensions == 2, "Dimensions should be two numbers: [x,y]")
        scene:setDimensions(unpack(sceneData.dimensions))
    end

    -- Root is just an actor with components just like anybody else.
    -- Root will be at 0,0 and can technically be reassigned although probably shouldn't.
    if sceneData.root then
        local actor = scene:addActor("root")
        DataLoader.loadComponentListData(actor, sceneData.root)
    end

    if sceneData.actors then
        for i, actorData in ipairs(sceneData.actors) do
            if actorData.prefab then
                DataLoader.loadPrefabData(scene, actorData)
            else
                DataLoader.loadActorData(scene, actorData)
            end
        end
    end

    return scene
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

-- Convenience
function Scene:getFirstActorWithBehavior(behavior)
    local result = {}

    for j, actor in ipairs(self.actors) do
        if actor[behavior.name] then
            return actor
        end
    end

    return nil
end

-- Convenience
function Scene:getFirstBehavior(behavior)
    for j, actor in ipairs(self.actors) do
        if actor[behavior.name] then
            return actor[behavior.name]
        end
    end
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
Scene:createEvent("onKeyPress", {"key", "scancode", "wasRelease"})
Scene:createEvent("onMouseMove", {"x", "y", "dx", "dy"})
Scene:createEvent("onScroll", {"x", "y"})
Scene:createEvent("onTextInput", {"text"})
Scene:createEvent("onMouseFocus", {"focus"})

-- Custom events
Scene:createEvent("onNotify", {"msg"})

-- MousePress has specialized behavior (click consuming) so it needs to be implemented directly
-- MousePress is handled in REVERSE order because we want them in order with drawing
function Scene:onMousePress(x, y, button, wasRelease)
    self.isClickConsumed = false
    for i, actor in ipairs(copyReversed(self.actors)) do
        actor:onMousePress(x, y, button, wasRelease, self.isClickConsumed)
    end
end

-- called by components in their onMousePress methods
function Scene:consumeClick()
    self.isClickConsumed = true
end

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
        if not actor.Layer then
            if actor.visible then
                local x, y = actor:pos().x - self.camera.x + shake.x, actor:pos().y - self.camera.y + shake.y
                actor:draw(x, y)
            end
        end
    end
end

function Scene:sendToBack(actor)
    local movedActor = deleteFromList(self.actors, actor)
    if movedActor then
        local actors = copyList(self.actors)
        self.actors = {}
        self.actors[1] = movedActor
        for i = 1, #actors do
            self.actors[i + 1] = actors[i]
        end
    end
end

return Scene
