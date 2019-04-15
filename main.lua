-- Global classes, you'll use vectors a lot so it's more convenient as globals
-- More performant to require vector every time though, so your call.
Vector = require("nx/vector")

-- In case you need a Json parser, that's here too
local Json = require("nx/json")

require("nx/util")
require("nx/update")
require("nx/input")
require("nx/componentregistry")
require("templating")
require("assets")

local Scene = require("nx/game/scene")
local Actor = require("nx/game/actor")

-- Global that everything has access to
gameScene = Scene.new(love.graphics.getDimensions())

local example = gameScene:addActor("SampleActor")
example.pos = Vector.new(30,30)
example:addComponent(Components.SampleComponent)

--[[
example:addComponent(Components.GridBrush)
example:addComponent(Components.GridRenderer)
example:addComponent(Components.CameraPan)
]]

function lastDraw()
    gameScene:draw(true)
end

function lastUpdate(dt)
    gameScene:update(dt,true)
end