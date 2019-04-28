-- Global classes, you'll use vectors a lot so it's more convenient as globals
-- More performant to require vector every time though, so your call.
Vector = require("nx/vector")

require("nx/util")
require("nx/input")
require("nx/componentregistry")
require("nx/template-loader")
require("nx/game/assets")

local Scene = require("nx/game/scene")
local Actor = require("nx/game/actor")

-- Global that everything has access to
gameScene = Scene.new(love.graphics.getDimensions())

function love.update(dt)
    gameScene:update(dt, true)
end

function love.draw()
    gameScene:draw(true)
end

gameScene = loadScene("physics", 200, 300)

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
r1:setLocalPos(300,300)
r1:addComponent(Components.BoundingBox)
r1:addComponent(Layer)
r1:addComponent(Components.Draggable)
r1:addComponent(SpriteRenderer):setup('linkin')

local r2 = gameScene:addActor("Rect 2")
r2:setLocalPos(332+16,332)
r2:addComponent(Components.BoundingBox)
r2:addComponent(Layer)
r2:addComponent(Components.Draggable)
r2:addComponent(SpriteRenderer):setup('linkin')

local r3 = gameScene:addActor("Rect 3")
r3:setLocalPos(332,340)
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
SpriteRendererExample:setLocalPos(200,200)
SpriteRendererExample:addComponent(Components.ControlAnimation)

local SpriteSheetRenderer = gameScene:addActor("Linkin the Newmaker")
SpriteSheetRenderer:addComponent(Components.SpriteSheetRenderer):setup('linkin',2)
SpriteSheetRenderer:setLocalPos(300,300)

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
differentRenderer:setLocalPos(100,400)

local bottle = Scene.new(200,200)
local renderer = gameScene:addActor("SceneRenderer")
renderer:addComponent(SceneRenderer):setup(bottle)
renderer:addComponent(Components.BoundingBox):setup(bottle.width,32,0,32)
renderer:addComponent(Components.Draggable)
renderer:addComponent(Layer)
renderer:setLocalPos(200,200)
bottle:addActor("BouncingBall"):addComponent(Components.BouncingBall)
bottle:addActor("Cursor"):addComponent(Components.Cursor)
]]

--[[
local r1 = gameScene:addActor("Rect 1")
r1:setLocalPos(300,300)
r1:addComponent(Components.BoundingBox)
r1:addComponent(Layer)
r1:addComponent(Components.Draggable)
r1:addComponent(SpriteRenderer):setup('linkin','stand',5)

local r2 = gameScene:addActor("Rect 2")
r2:setLocalPos(350,350)
r2:addComponent(Components.BoundingBox)
r2:addComponent(Layer)
r2:addComponent(Components.Draggable)
r2:addComponent(SpriteRenderer):setup('linkin','run',4)
r2:setParent(r1)

local r3 = gameScene:addActor("Rect 3")
r3:addComponent(Components.BoundingBox)
r3:addComponent(Layer)
r3:addComponent(Components.Draggable)
r3:addComponent(SpriteRenderer):setup('linkin','slash1',4)
r3:setParent(r2)
r3:setLocalPos(400,350)

local r4 = gameScene:addActor("Rect 3.5")
r4:setLocalPos(400,350)
r4:addComponent(SpriteRenderer):setup('linkin','slash1',4)
r4:setParent(r3)
]]

--[[
local angleBoy = gameScene:addActor("AngleBoy")
angleBoy:setLocalPos(200,200)
local cursor = gameScene:addActor("Cursor")
cursor:addComponent(Components.Cursor)
angleBoy:addComponent(Components.RotateTowards):setup(cursor)

local angleChild = gameScene:addActor("AngleChild")
angleChild:setParent(angleBoy)
angleChild:setPos(300,200)
angleChild:addComponent(Components.RotateTowards):setup(cursor)
]]
