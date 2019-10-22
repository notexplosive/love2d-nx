DEBUG = true

require("nx/util")
require("nx/input")

-- Global classes, for better performance these should be require'd in each file as needed
Assets = require("nx/game/assets")
Vector = require("nx/vector")
Size = require("nx/size")
Rect = require("nx/rect")

require("nx/componentregistry")

function love.update(dt)
    for _, scene in eachSceneReverseDrawOrder() do
        scene:update(dt, true)
    end
end

-- reverse from update
function love.draw()
    for _, scene in eachSceneDrawOrder() do
        scene:draw()
    end
end

function debugLog(str, ...)
    str = tostring(str)
    for i, v in ipairs({...}) do
        str = str .. "\t" .. tostring(v)
    end

    if uiScene then
        local debugRenderer = uiScene:getFirstBehavior(Components.DebugRenderer)
        if debugRenderer then
            debugRenderer:append(str)
            print(...)
        end
    end
end

local Test = require("nx/test")
Test.runComponentTests()

local Scene = require("nx/game/scene")
uiScene = Scene.fromPath("ui")
gameScene = Scene.fromPath("game")

taskbarIconFont = love.graphics.newFont(12)
iconFont = love.graphics.newFont(12)
windowTitleFont = love.graphics.newFont(16)

local sceneLayers = {}
append(sceneLayers, gameScene)
append(sceneLayers, uiScene)

function eachSceneDrawOrder()
    return ipairs(sceneLayers)
end

local reversedSceneLayers = copyReversed(sceneLayers)
function eachSceneReverseDrawOrder()
    return ipairs(reversedSceneLayers)
end

love.graphics.setBackgroundColor(15 / 255, 127 / 255, 127 / 255)
