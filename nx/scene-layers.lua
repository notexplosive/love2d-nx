local Scene = require("nx/game/scene")
local List = require("nx/list")

local SceneLayers = {}

function SceneLayers.new()
    local self = newObject(SceneLayers)
    self.layers = List.new()
    self.debugScene = Scene.new()
    return self
end

function SceneLayers:eachInDrawOrder()
    local list = self.layers:clone():add(self.debugScene)
    return list:each()
end

function SceneLayers:eachInReverseDrawOrder()
    local list = self.layers:clone():add(self.debugScene)
    return list:eachReversed()
end

function SceneLayers:onMousePress(x, y, button, wasRelease)
    local isConsumed = false
    for _, scene in self:eachInReverseDrawOrder() do
        scene.isClickConsumed = isConsumed
        local mousePoint = scene:getMousePosition(x, y)
        scene:onMousePress(mousePoint.x, mousePoint.y, button, wasRelease)
        if scene.isClickConsumed then
            isConsumed = true
        end
    end
end

function SceneLayers:onMouseMove(x, y, dx, dy)
    local isConsumed = false
    for _, scene in self:eachInReverseDrawOrder() do
        scene.isHoverConsumed = isConsumed
        local mousePoint = scene:getMousePosition(x, y)
        local mouseDelta = Vector.new(dx, dy) / scene:getScale()
        scene:onMouseMove(mousePoint.x, mousePoint.y, mouseDelta.x, mouseDelta.y)
        if scene.isHoverConsumed then
            isConsumed = true
        end
    end
end

function SceneLayers:onKeyPress(key, scancode, wasRelease)
    local isConsumed = false
    for _, scene in self:eachInReverseDrawOrder() do
        scene.isKeyConsumed = isConsumed
        scene:onKeyPress(key, scancode, wasRelease)
        if scene.isKeyConsumed then
            isConsumed = true
        end
    end
end

function SceneLayers:add(item)
    return self.layers:add(item)
end

function SceneLayers:clear()
    self.layers:clear()
end

function SceneLayers:getDebugScene()
    return self.debugScene
end

function SceneLayers:setDebugScene(scene)
    self.debugScene = scene
end

-- Singleton!
return SceneLayers
