-- Global classes, you'll use vectors a lot so it's more convenient as globals
-- More performant to require vector every time though, so your call.
Vector = require("nx/vector")

-- In case you need a Json parser, that's here too
local Json = require("nx/json")

require("nx/util")
require("nx/update")
require("nx/input")
require("nx/componentregistry")
require("nx/templating")
require("nx/game/assets")

local Scene = require("nx/game/scene")
local Actor = require("nx/game/actor")

-- Global that everything has access to
gameScene = Scene.new(love.graphics.getDimensions())
function lastDraw()
    gameScene:draw(true)
end

function lastUpdate(dt)
    gameScene:update(dt,true)
end

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


-- TODO: Make templating parser support templates, they'd be helpful here
--[[
local r1 = gameScene:addActor("Rect 1")
r1.pos = Vector.new(300,300)
r1:addComponent(Components.BoundingBox)
r1:addComponent(Layer)
r1:addComponent(Components.Draggable)
r1:addComponent(SpriteRenderer):setup('linkin')

local r2 = gameScene:addActor("Rect 2")
r2.pos = Vector.new(332+16,332)
r2:addComponent(Components.BoundingBox)
r2:addComponent(Layer)
r2:addComponent(Components.Draggable)
r2:addComponent(SpriteRenderer):setup('linkin')

local r3 = gameScene:addActor("Rect 3")
r3.pos = Vector.new(332,340)
r3:addComponent(Components.BoundingBox)
r3:addComponent(Layer)
r3:addComponent(Components.Draggable)
r3:addComponent(SpriteRenderer):setup('linkin')
]]

--[[
local dependencySample = gameScene:addActor("Depender the Defender")
dependencySample:addComponent(Components.SampleComponent)
dependencySample:addComponent(Components.DependencyExample)
]]

--[[
local SpriteRendererExample = gameScene:addActor("Linkin the Swordboy")
SpriteRendererExample:addComponent(SpriteRenderer):setup('linkin')
SpriteRendererExample.SpriteRenderer.scale = 4
SpriteRendererExample.pos = Vector.new(200,200)
SpriteRendererExample:addComponent(Components.ControlAnimation)

local SpriteSheetRenderer = gameScene:addActor("Linkin the Newmaker")
SpriteSheetRenderer:addComponent(Components.SpriteSheetRenderer):setup('linkin',2)
SpriteSheetRenderer.pos = Vector.new(300,300)

local TextLabel = gameScene:addActor("Instructions")
TextLabel:addComponent(TextRenderer):setup("Press number buttons to change animation")
]]

--[[
local bottle2 = Scene.new(300,300)
bottle2:addActor("BouncingBall"):addComponent(Components.BouncingBall)
bottle2:addActor("BouncingBall"):addComponent(Components.BouncingBall)
bottle2:addActor("BouncingBall"):addComponent(Components.BouncingBall)
bottle2:addActor("BouncingBall"):addComponent(Components.BouncingBall)
bottle2:addActor("Cursor"):addComponent(Components.Cursor)
local differentRenderer =  gameScene:addActor("SceneRenderer")
differentRenderer:addComponent(Components.BoundingBox):setup(bottle2.width,32,0,32)
differentRenderer:addComponent(Components.Draggable)
differentRenderer:addComponent(Layer)
differentRenderer:addComponent(SceneRenderer):setup(bottle2)
differentRenderer.pos = Vector.new(100,400)

local bottle = Scene.new(200,200)
local renderer = gameScene:addActor("SceneRenderer")
renderer:addComponent(SceneRenderer):setup(bottle)
renderer:addComponent(Components.BoundingBox):setup(bottle.width,32,0,32)
renderer:addComponent(Components.Draggable)
renderer:addComponent(Layer)
renderer.pos = Vector.new(200,200)
bottle:addActor("BouncingBall"):addComponent(Components.BouncingBall)
bottle:addActor("Cursor"):addComponent(Components.Cursor)
]]

local r1 = gameScene:addActor("Rect 1")
r1.pos = Vector.new(300,300)
r1:addComponent(Components.BoundingBox)
r1:addComponent(Layer)
r1:addComponent(Components.Draggable)
r1:addComponent(SpriteRenderer):setup('linkin','stand',5)

local r2 = gameScene:addActor("Rect 1")
r2.pos = Vector.new(350,350)
r2:addComponent(Components.BoundingBox)
r2:addComponent(Layer)
r2:addComponent(Components.Draggable)
r2:addComponent(SpriteRenderer):setup('linkin','run',4)