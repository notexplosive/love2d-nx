local Scene = require("nx/game/scene")
local DataLoader = require("nx/template-loader/data-loader")
local SceneRenderer = {}

registerComponent(SceneRenderer, "SceneRenderer", {"BoundingBox", "Canvas"})

-- equivalent to loadScene
function SceneRenderer:setup(pathOrScene, args)
    if type(pathOrScene) == "string" then
        local path = pathOrScene
        if args then
            assert(type(args) == "table", "SceneRenderer must take arguments as a list")
        end
        self.scene = Scene.fromPath(path, args)
    else
        local scene = pathOrScene
        self.scene = pathOrScene
    end

    self.scene:setDimensions(self.actor.Canvas:getDimensions())
end

function SceneRenderer:awake()
    if self.actor.BoundingBox then
        self.scene = Scene.new(self.actor.BoundingBox:getDimensions())
    end
end

function SceneRenderer:draw(x, y)
    if self.scene then
        self.actor.Canvas:canvasDraw(
            function()
                love.graphics.clear()
                love.graphics.setColor(200 / 255, 200 / 255, 180 / 255, 1)
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

    self.scene:setDimensions(self.actor.Canvas:getDimensions())
    if self.actor.Parent then
        local parent = self.actor.Parent:get()
        local editor = parent.BoundingBoxEditor
        if editor and editor:isDragging() or (parent.WindowDraggable and parent.WindowDraggable.dragging) then
            -- freeze update when dragging
            return
        end
    end
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
    if self.scene and not isHoverConsumed and hoveredOnScene then
        self.scene.isHoverConsumed = false
        self.actor:scene():consumeHover()
    end

    self.scene:onMouseMove(x, y, dx, dy)
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
            self.scene:onMousePress(x, y, button, wasRelease)
        end

        if clickedOnScene then
            self.actor:scene():consumeClick()
        end
    end

    if wasRelease then
        self.scene:onMousePress(x, y, button, wasRelease)
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

function SceneRenderer:onDestroy()
    self.scene:removeAllActors()
end


Scene:createEvent("onMinimize",{})
function SceneRenderer:onMinimize()
    self.scene:onMinimize()
end

return SceneRenderer
