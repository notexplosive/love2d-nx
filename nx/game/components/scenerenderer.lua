local SceneRenderer = {}

registerComponent(SceneRenderer, "SceneRenderer")

function SceneRenderer:setup(scene)
    assert(scene,"Scene is nil")
    self.scene = scene
    self.canvas = love.graphics.newCanvas(scene:getDimensions())
end

function SceneRenderer:awake()
    self.scene = nil
    self.canvas = nil
end

function SceneRenderer:draw(x, y)
    if self.scene then
        local oldCanvas = love.graphics.getCanvas()
        love.graphics.setCanvas(self.canvas)
        love.graphics.clear()
        love.graphics.setColor(1,0,1)
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
