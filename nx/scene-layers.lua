local Scene = require("nx/game/scene")
local List = require("nx/list")

local sceneLayers = List.new(Scene)

function sceneLayers:eachInDrawOrder()
    return self:each()
end

function sceneLayers:eachInReverseDrawOrder()
    return self:eachReversed()
end

function sceneLayers:onMousePress(x, y, button, wasRelease)
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

function sceneLayers:onMouseMove(x, y, dx, dy)
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

-- Tests
local Test = require("nx/test")
Test.run(
    "SceneLayers",
    function()
    end
)

-- Singleton!
return sceneLayers
