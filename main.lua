Json = require("nx/json")
Vector = require("nx/vector")
require("global")
require("nx/util")
require("nx/update")
require("nx/thirdparty")
require("nx/componentregistry")
require("mousekeyboard")
require("templating")
require("assets")

local Scene = require("nx/game/scene")
local Actor = require("nx/game/actor")

-- Global that everything has access to
gameScene = Scene.new(love.graphics.getDimensions())

local example = gameScene:addActor("SampleActor")
example:addComponent(Components.SampleComponent)

function lastDraw()
    gameScene:draw(true)
end

function lastUpdate(dt)
    gameScene:update(dt,true)
end