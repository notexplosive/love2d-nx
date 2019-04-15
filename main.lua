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

--[[
local example = gameScene:addActor("SampleActor")
example:addComponent(Components.SampleComponent)
]]

-- TODO: make this into Json, fix templater
--[[
example:addComponent(Components.GridBrush)
example:addComponent(Components.GridRenderer)
example:addComponent(Components.CameraPan)
]]

local r1 = gameScene:addActor("Rect 1")
local r2 = gameScene:addActor("Rect 2")
local r3 = gameScene:addActor("Rect 3")
-- TODO: Make templating parser support templates, they'd be helpful here
r1.pos = Vector.new(300,300)
r1:addComponent(Components.BoundingBox)
r1:addComponent(Components.Layer)
r1:addComponent(Components.Draggable)

r2.pos = Vector.new(332+16,332)
r2:addComponent(Components.BoundingBox)
r2:addComponent(Components.Layer)
r2:addComponent(Components.Draggable)

r3.pos = Vector.new(332,340)
r3:addComponent(Components.BoundingBox)
r3:addComponent(Components.Layer)
r3:addComponent(Components.Draggable)

function lastDraw()
    gameScene:draw(true)
end

function lastUpdate(dt)
    gameScene:update(dt,true)
end