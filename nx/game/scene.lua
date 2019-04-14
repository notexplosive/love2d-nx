local Actor = require('nx/game/actor')
local Vector = require('nx/vector')
local Scene = {}

function Scene.new(width,height)
    local self = newObject(Scene)
    self.hasStarted = false
    self.actors = {}
    self.originalActors = {}
    self.width = width
    self.height = height
    self.freeze = false
    self.camera = Vector.new(0,0)

    -- Scene Shake
    self.shakeFrames = 0
    self.shakeVariance = 0

    if width == nil then
        self.width = love.graphics.getWidth()
        self.height = love.graphics.getHeight()
    end

    return self
end

function Scene:update(dt,inFocus)
    -- Run any applicable start functions
    for i,actor in ipairs(self.actors) do
        if actor._justAddedToScene then
            actor._justAddedToScene = nil
            actor:start()
        end
    end

    for i,actor in ipairs(self.actors) do
        if not self.freeze then
            actor:sceneUpdate(dt,inFocus)
        end
    end
end

-- NOTE: inFocus does nothing if we're not in Fenestra, if this is on github for nx, remove it
function Scene:draw(inFocus)
    local shake = Vector.new()
    if self.shakeFrames > 0 then
        shake.x = love.math.random(-self.shakeVariance,self.shakeVariance)
        shake.y = love.math.random(-self.shakeVariance,self.shakeVariance)
        self.shakeFrames = self.shakeFrames - 1
    end

    for i,actor in ipairs(self.actors) do
        if actor.visible then
            local x,y = actor.pos.x - self.camera.x + shake.x,actor.pos.y - self.camera.y + shake.y
            actor:draw(inFocus,x,y)
        end
    end

    if self.lastDraw then
        self.lastDraw()
    end
end

function Scene:onKeyPress(key,scancode,isRepeat)
    for i,actor in ipairs(self.actors) do
        actor:onKeyPress(key,scancode,isRepeat)
    end
end

function Scene:textEntered(string)
    for i,actor in ipairs(self.actors) do
        actor:textEntered(string)
    end
end

-- Add actor to list
function Scene:addActor(actor, ...)
    assert(actor ~= nil,"Scene:addActor must take at least one argument")
    if type(actor) == 'string' then
        return self:addActor(Actor.new(actor))
    end

    assert(actor.type == Actor,"Can't add a non-actor to a scene")

    if actor.parentScene == nil then
        actor.parentScene = self
    end

    --actor.scene = self
    if actor.originalScene == nil then
        actor.originalScene = self
        append(self.originalActors,actor)
    end

    actor._justAddedToScene = true
    append(self.actors,actor)

    if ... then
        for i,v in ipairs({...}) do
            self:addActor(v)
        end
    end

    return actor
end

-- Get actor by name
function Scene:getActor(actorName)
    assert(actorName)
    for i,actor in ipairs(self.actors) do
        if actor.name == actorName then
            return actor,i
        end
    end

    return nil
end

-- Get index of actor in actor list
function Scene:getActorIndex(actor)
    assert(actor)
    for i,iactor in ipairs(self.actors) do
        if iactor == actor then
            return i
        end
    end

    return nil
end

function Scene:destroyAllActors()
    local actors = self:getAllActors()
    for i,v in ipairs(actors) do
        v:destroy()
    end
end

function Scene:getAllActors()
    return copyList(self.actors)
end

function Scene:onScroll(dx,dy)
    if self.shakeFrames > 0 then
        return
    end

    self.camera.x = self.camera.x - dx
    self.camera.y = self.camera.y - dy

    if self.camera.x < 0 then
        self.camera.x = 0
    end

    if self.camera.y < 0 then
        self.camera.y = 0
    end

    if self.camera.y > (self.bottomPos or 0) then
        self.camera.y = (self.bottomPos or 0)
    end

    if self.camera.x > (self.rightMostPos or 0) then
        self.camera.x = (self.rightMostPos or 0)
    end
end

function Scene:onClick(x,y,button,wasRelease)
    self:propagate('onClick',{x,y,button,wasRelease})
end

function Scene:onLoseFocus()
    self:propagate('onLoseFocus')
end

-- MAKE SURE CONDITION IS function(actor) and DOES NOT USE SELF
function Scene:propagate(func,args,condition)
    for i,actor in ipairs(self.actors) do
        if condition and condition(actor) then
            actor[func](actor,unpack(args))
        end
    end
end

function Scene:getAllActorsWithBehavior(behavior)
    local result = {}
    local i = 1

    for j,actor in ipairs(self.actors) do
        if actor[behavior.name] then
            result[i] = actor
            i = i + 1
        end
    end

    return result
end

function Scene:getBounds()
    return 0,0,self.width,self.height
end

function Scene:getDimensions()
    return self.width,self.height
end

function Scene:shake(frames,variance)
    self.shakeFrames = frames or 5
    self.shakeVariance = variance or 2
end

return Scene