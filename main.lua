ALLOW_DEBUG = true
DEBUG = false

require("nx/util")
require("nx/input")
require("nx/debug-log")

local SceneLayers = require("nx/scene-layers")
local Test = require("nx/test")
local Scene = require("nx/game/scene")

sceneLayers = SceneLayers.new()

function love.update(dt)
    for _, scene in sceneLayers:eachInReverseDrawOrder() do
        scene:update(dt, true)
    end
end

function love.draw()
    for _, scene in sceneLayers:eachInDrawOrder() do
        scene:draw()
    end
end

function love.quit()
    for _, scene in sceneLayers:eachInReverseDrawOrder() do
        scene:onApplicationClose()
    end
end

function runGame()
    collectgarbage("collect")
    sceneLayers:clear()
    sceneLayers:add(Scene.fromJson("game"))
    sceneLayers:add(Scene.fromJson("ui"))
    sceneLayers:setDebugScene(Scene.fromJson("debug"))
end

function love.load(argv)
    -- Global classes, for better performance these should be require'd in each file as needed
    Assets = require("nx/game/assets")
    Vector = require("nx/vector")
    Size = require("nx/size")
    Rect = require("nx/rect")
    List = require("nx/list")
    Color = require("nx/color")

    require("nx/component-registry")

    Test.runComponentTests()

    runGame()

    love.graphics.setBackgroundColor(0 / 255, 127 / 255, 255 / 255)

    if ALLOW_DEBUG then
        debugLog("ALLOW_DEBUG is enabled")
    end
end
