local Actor = require("nx/game/actor")
local List = require("nx/list")
local Vector = require("nx/vector")
local DataLoader = require("nx/template-loader/data-loader")
local Scene = {}

function Scene.new(width, height)
    local self = newObject(Scene)
    self.actors = List.new()
    self:setDimensions(width, height)
    self.freeze = false
    self.world = love.physics.newWorld(0, 9.8, true)

    self.isClickConsumed = false
    self.isHoverConsumed = false
    self.isKeyConsumed = false

    self.viewport = nil

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
        -- Root cannot be positioned, angled, or edited, even though it's otherwise an "Actor"
        -- Ideally I'd like "ComponentList" to be its own object, and actor.components is a "ComponentList"
        local actor = scene:addActor("root")
        scene:setRoot(actor)
        actor:addComponent(Components.Uneditable)
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

function Scene:setRoot(actor)
    local notSupportedFunction = function(fnName)
        return function()
            assert(false, "Root does not support " .. fnName)
        end
    end
    actor.isRoot = true
    actor.setPos = notSupportedFunction("setPos()")
    actor.setAngle = notSupportedFunction("setAngle()")

    self.root = actor
end

function Scene:getRoot()
    assert(self.root, "Scene does not have a root")
    return self.root
end

function Scene:setDimensions(width, height)
    self.width = width
    self.height = height
end

function Scene:setViewport(viewportComponent)
    self.viewport = viewportComponent
end

function Scene:getViewport()
    return self.viewport
end

function Scene:getViewportPosition()
    if self.viewport then
        return self.viewport.actor:pos()
    else
        return Vector.new()
    end
end

function Scene:setViewportPosition(pos)
    if self.viewport then
        self.viewport.actor:setPos(pos)
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

function Scene:getFirstActorWithBehaviorIfExists(behavior)
    assert(behavior, "null component")
    local actors = self:getAllActorsWithBehavior(behavior)
    if #actors == 0 then
        return nil
    end
    return actors[1]
end

function Scene:getFirstBehavior(behavior)
    assert(behavior, "null component")
    local actors = self:getAllActorsWithBehavior(behavior)
    assert(
        #actors > 0,
        "No actors with behavior " .. behavior.name .. " if this is a valid case then use getFirstBehaviorIfExists"
    )
    return actors[1][behavior.name]
end

function Scene:getFirstBehaviorIfExists(behavior)
    assert(behavior, "null component")
    local actors = self:getAllActorsWithBehavior(behavior)
    if #actors == 0 then
        return nil
    end
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
Scene.getFirstComponent = Scene.getFirstBehavior
Scene.getFirstActorWith = Scene.getFirstActorWithBehavior
Scene.getFirstActorWithIfExists = Scene.getFirstActorWithBehaviorIfExists
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

function Scene:getMousePosition(x, y)
    if self.gameCanvas then
        return self.gameCanvas:screenPosToCanvasPos(x, y)
    else
        return Vector.new(x, y) / self:getScale() + self:getViewportPosition()
    end
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
Scene:createEvent("onScroll", {"x", "y"})
Scene:createEvent("onTextInput", {"text"})
Scene:createEvent("onMouseFocus", {"focus"})
Scene:createEvent("onWindowResize", {"newWidth", "newHeight"})

-- Custom events
Scene:createEvent("onNotify", {"msg"})
Scene:createEvent("onApplicationClose", {})
Scene:createEvent("uiDraw", {}) -- Draw after viewport

-- Keypress is handled in REVERSE order because we want them in order with drawing
function Scene:onKeyPress(key, scancode, wasRelease)
    for i, actor in self.actors:cloneReversed():each() do
        actor:onKeyPress(key, scancode, wasRelease, self.isKeyConsumed)
    end
end

-- MousePress is handled in REVERSE order because we want them in order with drawing
function Scene:onMousePress(x, y, button, wasRelease)
    for i, actor in self.actors:cloneReversed():each() do
        actor:onMousePress(x, y, button, wasRelease, self.isClickConsumed)
    end
end

-- MousePress is handled in REVERSE order because we want them in order with drawing
function Scene:onMouseMove(x, y, dx, dy)
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

function Scene:consumeKeyPress()
    self.isKeyConsumed = true
end

-- Game Events: These are special events that don't work like regular events
function Scene:update(dt)
    for i, actor in self.actors:clone():each() do
        if actor.isDestroyed then
            actor:removeFromScene()
        end
    end

    for i, actor in self.actors:clone():each() do
        if not self.freeze then
            actor:update(dt)
        end
    end
end

function Scene:shake(frames, magnitude)
    if self.viewport then
        self.viewport:shake(frames, magnitude)
    else
        debugLog("Shake ignored because there's no viewport")
    end
end

function Scene:setGameCanvas(gameCanvasComponent)
    self.gameCanvas = gameCanvasComponent
end

function Scene:getGameCanvas()
    return self.gameCanvas
end

function Scene:draw()
    if self.viewport then
        if self.gameCanvas then
            self.gameCanvas:screenDraw()
        else
            self:draw_impl()
        end
        self:uiDraw()
    else
        self:draw_impl()
        self:uiDraw()
    end
end

function Scene:draw_impl()
    for i, actor in self.actors:each() do
        if actor.visible then
            local x, y = actor:pos().x, actor:pos().y
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
