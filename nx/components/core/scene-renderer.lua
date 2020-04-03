local Scene = require("nx/game/scene")
local DataLoader = require("nx/template-loader/data-loader")
local SceneRenderer = {}

registerComponent(SceneRenderer, "SceneRenderer", {"Canvas"})

-- equivalent to loadScene
function SceneRenderer:setup(pathOrScene, args)
    if type(pathOrScene) == "string" then
        local path = pathOrScene
        if args then
            assert(type(args) == "table", "SceneRenderer must take arguments as a list")
        end
        self.scene = Scene.fromJson(path, args)
    else
        local scene = pathOrScene
        self.scene = pathOrScene
    end

    self.scene:setDimensions(self.actor.Canvas:getDimensions())
end

function SceneRenderer:awake()
    self.scene = Scene.new(self.actor.Canvas:getDimensions())
    self.backgroundColor = {200 / 255, 200 / 255, 180 / 255, 1}
end

function SceneRenderer:draw(x, y)
    if self.scene then
        self.actor.Canvas:canvasDraw(
            function()
                love.graphics.clear()
                love.graphics.setColor(self.backgroundColor)
                love.graphics.rectangle("fill", 0, 0, self.actor.Canvas:getDimensions())
                love.graphics.setColor(1, 1, 1, 1)
                self.scene:draw()
            end
        )
    end
end

function SceneRenderer:update(dt)
    if not self.actor.visible then
        -- fenestra hack: should not capture/uncapture with a minimized lens window
        return
    -- /fenestra hack
    end

    -- fenestra hack, kind of?
    --self.scene:setDimensions(self.actor.Canvas:getDimensions())
    -- /fenestra hack

    if self.scene then
        self.scene:update(dt)
    end
end

function SceneRenderer:onMouseMove(x, y, dx, dy, isHoverConsumed)
    if not self.actor.visible then
        return
    end

    local hoveredOnScene = self.actor.Canvas:getRect():isVectorWithin(x, y)

    x = x - self.actor:pos().x
    y = y - self.actor:pos().y
    if self.scene then
        if hoveredOnScene and not isHoverConsumed then
            self.actor:scene():consumeHover()
            self.scene.isHoverConsumed = false
        else
            self.scene.isHoverConsumed = true
        end
        self.scene:onMouseMove(x + self.scene:getViewportPosition().x, y + self.scene:getViewportPosition().y, dx, dy)
    end
end

function SceneRenderer:onMousePress(x, y, button, wasRelease, isClickConsumed)
    if not self.actor.visible then
        return
    end

    local clickedOnScene = self.actor.Canvas:getRect():isVectorWithin(x, y)

    x = x - self.actor:pos().x
    y = y - self.actor:pos().y
    if self.scene and not isClickConsumed then
        self.scene.isClickConsumed = false
        if not wasRelease then
            self.scene:onMousePress(
                x + self.scene:getViewportPosition().x,
                y + self.scene:getViewportPosition().y,
                button,
                wasRelease
            )
        end

        if clickedOnScene then
            self.actor:scene():consumeClick()
        end
    end

    if wasRelease then
        self.scene:onMousePress(
            x + self.scene:getViewportPosition().x,
            y + self.scene:getViewportPosition().y,
            button,
            wasRelease
        )
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
    if not self.actor.visible or not self:isInFocus() then
        return
    end

    if self.scene then
        self.scene:onKeyPress(key, scancode, wasRelease)
    end
end

function SceneRenderer:onTextInput(text)
    if not self.actor.visible or not self:isInFocus() then
        return
    end

    if self.scene then
        self.scene:onTextInput(text)
    end
end

function SceneRenderer:onDestroy()
    self.scene:removeAllActors()
end

function SceneRenderer:appendFromJson(path)
    Scene.appendFromJson(path, self.scene)
end

-- fenestra hack
Scene:createEvent("onMinimize", {"becameVisible"})
function SceneRenderer:onMinimize(becameVisible)
    self.scene:onMinimize(becameVisible)
end
-- /fenestra hack

-- fenestra hack, as well as its usages
function SceneRenderer:isInFocus()
    return self.actor.WindowExternal:isInFocus()
end
-- /fenestra hack

return SceneRenderer
