local Actor = require("nx/game/actor")
local Vector = require("nx/vector")
local DataLoader = require("nx/template-loader/data-loader")
local Scene = {}

function Scene.new(width, height)
    local self = newObject(Scene)
    self.hasStarted = false
    self.actors = List.new()
    self:setDimensions(width, height)
    self.freeze = false
    self.world = love.physics.newWorld(0, 9.8, true)
    self.isClickConsumed = false
    self.isHoverConsumed = false
    self.viewport = nil

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
            DataLoader.loadActorData(scene, actorData)
        end
    end

    return scene
end

function Scene.fromJson(path, ...)
    local args = {...}
    local sceneData = DataLoader.loadTemplateFile("scenes/" .. path .. ".json", args)
    local scene = Scene.fromSceneData(sceneData)
    return scene
end

function Scene.appendFromJson(path, sceneToAppendTo)
    assert(sceneToAppendTo, "Must supply scene to append to")
    local sceneData = DataLoader.loadTemplateFile("scenes/" .. path .. ".json", args)
    local scene = Scene.fromSceneData(sceneData, sceneToAppendTo)
end

function Scene:setDimensions(width, height)
    self.width = width
    self.height = height
end

function Scene:setViewport(viewportComponent)
    self.viewport = viewportComponent
end

function Scene:getViewport(viewportComponent)
    return self.viewport
end

function Scene:getViewportPosition()
    if self.viewport then
        return self.viewport.actor:pos()
    else
        return Vector.new()
    end
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

    self.actors:add(actor)

    return actor
end

-- Get actor by name
function Scene:getActor(actorName)
    assert(actorName)
    for i, actor in self.actors:each() do
        if actor.name == actorName then
            return actor, i
        end
    end

    return nil
end

-- Get index of actor in actor list
function Scene:getActorIndex(actor)
    assert(actor)
    for i, iactor in self.actors:each() do
        if iactor == actor then
            return i
        end
    end

    return nil
end

function Scene:destroyAllActors()
    local actors = self.actors:clone()
    for i, v in actors:each() do
        v:destroy()
    end
end

function Scene:removeAllActors()
    local actors = self.actors:clone()
    for i, v in actors:each() do
        v:removeFromScene()
    end
end

function Scene:getAllActors()
    return self.actors:copyInner()
end

function Scene:getAllActorsWithBehavior(behavior)
    assert(behavior, "null component")
    local result = {}
    local i = 1

    for j, actor in self.actors:each() do
        if (not actor.isDestroyed) and actor[behavior.name] then
            result[i] = actor
            i = i + 1
        end
    end

    return result
end

function Scene:getFirstActorWithBehavior(behavior)
    assert(behavior, "null component")
    local actors = self:getAllActorsWithBehavior(behavior)
    assert(#actors > 0, "No actors with behavior " .. behavior.name)
    return actors[1]
end

function Scene:getFirstBehavior(behavior)
    assert(behavior, "null component")
    local actors = self:getAllActorsWithBehavior(behavior)
    assert(#actors > 0, "No actors with behavior " .. behavior.name)
    return actors[1][behavior.name]
end

-- for i,actor in self.actor:scene():eachActorWith(Components.foo) do
function Scene:eachActor()
    return self.actors:clone():each()
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

-- Ordering functions, o(n)
function Scene:sendToBack(actor)
    assert(actor, "sendToBack needs one argument")
    local movedActor = self.actors:removeFromList(actor)
    if movedActor then
        self.actors:enqueue(movedActor)
    end

    actor:onSendToBack()
end

function Scene:bringToFront(actor)
    assert(actor, "bringToFront needs one argument")
    local movedActor = self.actors:removeElement(actor)
    if movedActor then
        self.actors:add(movedActor)
    end

    actor:onBringToFront()
end

function Scene:getScale()
    if self.viewport then
        return self.viewport:getScale()
    else
        return 1
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
Scene:createEvent("onApplicationClose", {})

-- MousePress is handled in REVERSE order because we want them in order with drawing
function Scene:onMousePress(x, y, button, wasRelease)
    --self.isClickConsumed = false
    for i, actor in self.actors:cloneReversed():each() do
        actor:onMousePress(x, y, button, wasRelease, self.isClickConsumed)
    end
end

-- MousePress is handled in REVERSE order because we want them in order with drawing
function Scene:onMouseMove(x, y, dx, dy)
    --self.isHoverConsumed = false
    for i, actor in self.actors:cloneReversed():each() do
        actor:onMouseMove(x, y, dx, dy, self.isHoverConsumed)
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
    for i, actor in self.actors:clone():each() do
        if actor.isDestroyed then
            actor:removeFromScene()
        end
    end

    -- Run any applicable start functions
    for i, actor in self.actors:clone():each() do
        if actor._hasNotRunStart then
            actor._hasNotRunStart = nil
            actor:start()
        end
    end

    for i, actor in self.actors:clone():each() do
        if not self.freeze then
            actor:update(dt)
        end
    end
end

function Scene:draw()
    if self.viewport then
        self.viewport:sceneDraw()
    else
        self:draw_impl()
    end
end

function Scene:draw_impl()
    local shake = Vector.new()
    if self.shakeFrames > 0 then
        shake.x = love.math.random(-self.shakeVariance, self.shakeVariance)
        shake.y = love.math.random(-self.shakeVariance, self.shakeVariance)
        self.shakeFrames = self.shakeFrames - 1
    end

    for i, actor in self.actors:each() do
        if actor.visible then
            local x, y = actor:pos().x + shake.x, actor:pos().y + shake.y
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
