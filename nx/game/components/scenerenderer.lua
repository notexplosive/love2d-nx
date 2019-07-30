local Scene = require("nx/game/scene")
local DataLoader = require("nx/template-loader/data-loader")
local SceneRenderer = {}

registerComponent(SceneRenderer, "SceneRenderer", {"BoundingBox"})

-- equivalent to loadScene
function SceneRenderer:setup(path, args)
    if args then
        assert(type(args) == "table", "SceneRenderer must take arguments as a list")
    end
    local sceneData = DataLoader.loadTemplateFile("scenes/" .. path .. ".json", args)
    self.scene = DataLoader.loadSceneData(sceneData, self.scene)
end

function SceneRenderer:awake()
    if self.actor.BoundingBox then
        self.scene = Scene.new(self.actor.BoundingBox:getDimensions())
    end
    self.canvas = love.graphics.newCanvas(self.scene:getDimensions())
end

function SceneRenderer:draw(x, y)
    if self.scene then
        local oldCanvas = love.graphics.getCanvas()
        love.graphics.setCanvas(self.canvas)
        love.graphics.clear()
        love.graphics.setColor(0.5, 0, 0.5, 1)
        love.graphics.rectangle("fill", 0, 0, self.canvas:getDimensions())
        love.graphics.setColor(1, 1, 1, 1)
        self.scene:draw()
        love.graphics.setCanvas(oldCanvas)
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(self.canvas, x, y)
    end
end

function SceneRenderer:update(dt)
    if self.scene then
        self.scene:update(dt)
    end
end

function SceneRenderer:onMouseMove(x, y, dx, dy)
    if not self.actor.visible then
        return
    end

    x = x - self.actor:pos().x
    y = y - self.actor:pos().y
    if self.scene then
        self.scene:onMouseMove(x, y, dx, dy)
    end
end

function SceneRenderer:onMousePress(x, y, button, wasRelease, isClickConsumed)
    if not self.actor.visible then
        return
    end

    x = x - self.actor:pos().x
    y = y - self.actor:pos().y
    if self.scene and not isClickConsumed then
        self.scene:onMousePress(x, y, button, wasRelease)

        -- If you clicked on something clickable inside the subscene, consume click in host scene
        if self.scene.isClickConsumed then
            self.actor:scene():consumeClick()
        end
    end
end

function SceneRenderer:onScroll(x, y)
    if not self.actor.visible then
        return
    end

    if self.scene then
        self.scene:onScroll(x, y)
    end
end

function SceneRenderer:onKeyPress(key, scancode, wasRelease)
    if not self.actor.visible then
        return
    end

    if self.scene then
        self.scene:onKeyPress(key, scancode, wasRelease)
    end
end

function SceneRenderer:onTextInput(text)
    if not self.actor.visible then
        return
    end

    if self.scene then
        self.scene:onTextInput(text)
    end
end

return SceneRenderer
