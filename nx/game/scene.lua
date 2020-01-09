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
    self.isHoverConsumed = false

    -- Scene Shake
    self.shakeFrames = 0
    self.shakeVariance = 0

    if width == nil then
        self:setDimensions(love.graphics.getDimensions())
    end

    return self
end

function Scene.fromSceneData(sceneData, sceneToAppendTo)
    local scene = sceneToAppendTo or Scene.new()

    if sceneData.dimensions then
        assert(#sceneData.dimensions == 2, "Dimensions should be two numbers: [x,y]")
        scene:setDimensions(unpack(sceneData.dimensions))
    end

    -- Root is just an actor with components just like anybody else.
    -- Root will be at 0,0 and can technically be reassigned although probably shouldn't.
    if sceneData.root then
        local actor = scene:addActor("root")
        actor:addComponent(Components.Serializable) -- code smell!
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

function Scene.fromPath(path, ...)
    local args = {...}
    local sceneData = DataLoader.loadTemplateFile("scenes/" .. path .. ".json", args)
    local scene = Scene.fromSceneData(sceneData)
    return scene
end

function Scene.appendFromPath(path, sceneToAppendTo)
    assert(sceneToAppendTo, "Must supply scene to append to")
    local sceneData = DataLoader.loadTemplateFile("scenes/" .. path .. ".json", args)
    local scene = Scene.fromSceneData(sceneData, sceneToAppendTo)
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
    if not actor._hasNotRunStart then -- fenestra hack
        actor._hasNotRunStart = true
    end -- /fenestra hack

    append(self.actors, actor)

    return actor
end

function Scene:addPrefab(prefabName, ...)
    -- Dehydrate the actor to a prefab node
    local nodeData = {
        prefab = prefabName,
        arguments = {...}
    }

    local actor = DataLoader.loadPrefabData(self, nodeData)

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

function Scene:removeAllActors()
    local actors = self:getAllActors()
    for i, v in ipairs(actors) do
        v:removeFromScene()
    end
end

function Scene:getAllActors()
    return copyList(self.actors)
end

function Scene:getAllActorsWithBehavior(behavior)
    assert(behavior, "null component")
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
    assert(behavior, "null component")
    local result = {}

    for j, actor in ipairs(self.actors) do
        if actor[behavior.name] then
            return actor
        end
    end

    return nil
end

function Scene:getFirstBehavior(behavior)
    assert(behavior, "null component")
    for j, actor in ipairs(self.actors) do
        if actor[behavior.name] then
            return actor[behavior.name]
        end
    end
end

-- for i,actor in self.actor:scene():eachActorWith(Components.foo) do
function Scene:eachActor()
    return ipairs(copyList(self.actors))
end

function Scene:eachActorWith(componentClass)
    return ipairs(self:getAllActorsWith(componentClass))
end

function Scene:eachActorWithReversed(componentClass)
    return ipairs(copyReversed(self:getAllActorsWith(componentClass)))
end

-- aliases, eventually "Behavior" will become "Component"
Scene.getFirstComponent = Scene.getfirstBehavior
Scene.getFirstActorWith = Scene.getFirstActorWithBehavior
Scene.getAllActorsWith = Scene.getAllActorsWithBehavior

-- Ordering functions
function Scene:sendToBack(actor)
    assert(actor, "sendToBack needs one argument")
    local movedActor = deleteFromList(self.actors, actor)
    if movedActor then
        local actors = copyList(self.actors)
        self.actors = {}
        self.actors[1] = movedActor
        for i = 1, #actors do
            self.actors[i + 1] = actors[i]
        end
    end

    actor:callForAllComponents("onSendToBack")
end

function Scene:bringToFront(actor)
    assert(actor, "bringToFront needs one argument")
    local movedActor = deleteFromList(self.actors, actor)
    if movedActor then
        append(self.actors, movedActor)
    end

    actor:callForAllComponents("onBringToFront")

    if actor.Children then
        for i, child in ipairs(actor.Children:get()) do
            self:bringToFront(child)
        end
    end
end

function Scene:getBounds()
    return 0, 0, self.width, self.height
end

function Scene:getDimensions()
    return self.width, self.height
end

function Scene:getRect()
    return Rect.new(0, 0, self.width, self.height)
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
Scene:createEvent("onScroll", {"x", "y"})
Scene:createEvent("onTextInput", {"text"})
Scene:createEvent("onMouseFocus", {"focus"})

-- Custom events
Scene:createEvent("onNotify", {"msg"})

-- MousePress is handled in REVERSE order because we want them in order with drawing
function Scene:onMousePress(x, y, button, wasRelease)
    --self.isClickConsumed = false
    for i, actor in ipairs(copyReversed(self.actors)) do
        actor:onMousePress(x + self.camera.x, y + self.camera.y, button, wasRelease, self.isClickConsumed)
    end
end

-- MousePress is handled in REVERSE order because we want them in order with drawing
function Scene:onMouseMove(x, y, dx, dy)
    --self.isHoverConsumed = false
    for i, actor in ipairs(copyReversed(self.actors)) do
        actor:onMouseMove(x + self.camera.x, y + self.camera.y, dx, dy, self.isHoverConsumed)
    end
end

-- called by components in their onMousePress methods
function Scene:consumeClick()
    self.isClickConsumed = true
end

function Scene:consumeHover()
    self.isHoverConsumed = true
end

-- Game Events: These are special events that don't work like regular events
function Scene:update(dt)
    for i, actor in ipairs(copyList(self.actors)) do
        if actor.isDestroyed then
            actor:removeFromScene()
        end
    end

    -- Run any applicable start functions
    for i, actor in ipairs(self.actors) do
        if actor._hasNotRunStart then
            actor._hasNotRunStart = nil
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
            local x, y = actor:pos().x - self.camera.x + shake.x, actor:pos().y - self.camera.y + shake.y
            actor:draw(x, y)
        end
    end
end

-- fenestra hack
function Scene:window()
    local ref = self:getFirstBehavior(Components.WindowInternal)
    return ref
end
--

return Scene
