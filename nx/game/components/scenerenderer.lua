local Scene = require('nx/game/scene')
local SceneRenderer = {}


registerComponent(SceneRenderer, "SceneRenderer")

-- equivalent to loadScene
function SceneRenderer:setup(path,args)
    local sceneData = loadTemplateFile("scenes/" .. path .. ".json",args)
    self.scene = loadSceneData(sceneData,self.scene)
end

function SceneRenderer:awake()
    if self.actor.BoundingBox then
        self.scene = Scene.new(self.actor.BoundingBox:getDimensions())
    else
        self.scene = Scene.new(128,32)
    end
    self.canvas = love.graphics.newCanvas(self.scene:getDimensions())
end

function SceneRenderer:draw(x, y)
    if self.scene then
        local oldCanvas = love.graphics.getCanvas()
        love.graphics.setCanvas(self.canvas)
        love.graphics.clear()
        love.graphics.setColor(0.5,0,0.5)
        love.graphics.rectangle('fill', 0, 0, self.canvas:getDimensions())
        love.graphics.setColor(1,1,1)
        self.scene:draw()
        love.graphics.setCanvas(oldCanvas)
        love.graphics.draw(self.canvas, x, y)
    end
end

function SceneRenderer:update(dt)
    if self.scene then
        self.scene:update(dt)
    end
end

function SceneRenderer:onMouseMove(x, y, dx, dy)
    x = x - self.actor:pos().x
    y = y - self.actor:pos().y
    if self.scene then
        self.scene:onMouseMove(x, y, dx, dy)
    end
end

function SceneRenderer:onMousePress(x, y, button, wasRelease)
    if self.scene then
        self.scene:onMousePress(x, y, button, wasRelease)
    end
end

function SceneRenderer:onScroll(x, y)
    if self.scene then
        self.scene:onScroll(x, y)
    end
end

function SceneRenderer:onKeyPress(key, scancode, wasRelease)
    if self.scene then
        self.scene:onKeyPress(key, scancode, wasRelease)
    end
end

return SceneRenderer
