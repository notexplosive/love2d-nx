--- DEBUG
DEBUG = true

require("nx/util")
require("nx/input")
require("nx/componentregistry")
require("nx/template-loader/api")
require("nx/game/assets")

-- Global classes, you'll use vectors a lot so it's more convenient as globals
-- More performant to require vector every time though, so your call.
Vector = require("nx/vector")
Size = require("nx/size")
Rect = require("nx/rect")

local Scene = require("nx/game/scene")

-- Global that everything has access to
gameScene = Scene.new(love.graphics.getDimensions())
uiScene = Scene.new(love.graphics.getDimensions())

function love.update(dt)
    uiScene:update(dt, true)
    gameScene:update(dt, true)
end

-- reverse from update
function love.draw()
    gameScene:draw(true)
    uiScene:draw(true)
end

function debugLog(str, ...)
    if DEBUG then
        str = tostring(str)
        for i, v in ipairs({...}) do
            str = str .. "\t" .. tostring(v)
        end
        local debugRenderers = uiScene:getAllActorsWithBehavior(Components.DebugRenderer)
        if debugRenderers[1] then
            debugRenderers[1].DebugRenderer:append(str)
            print(str, ...)
        end
    else
        print(str, ...)
    end
end

gameScene = loadScene("game")
uiScene = loadScene("ui")

if DEBUG then
    debugLog(love.window.getTitle())
    debugLog("DebugMode is enabled")
end