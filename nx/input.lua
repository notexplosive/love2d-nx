local sceneLayers = require("nx/scene-layers")

function love.mousepressed(x, y, button)
    love.mousemoved(x, y, 0, 0)
    local isConsumed = false
    for _, scene in sceneLayers:eachInReverseDrawOrder() do
        scene.isClickConsumed = isConsumed
        local mousePoint = Vector.new(x, y) / scene:getScale() + scene:getViewportPosition()
        scene:onMousePress(mousePoint.x, mousePoint.y, button, false)
        if scene.isClickConsumed then
            isConsumed = true
        end
    end
end

function love.mousereleased(x, y, button)
    love.mousemoved(x, y, 0, 0)
    local isConsumed = false
    for _, scene in sceneLayers:eachInReverseDrawOrder() do
        scene.isClickConsumed = isConsumed
        local mousePoint = Vector.new(x, y) / scene:getScale() + scene:getViewportPosition()
        scene:onMousePress(mousePoint.x, mousePoint.y, button, true)
        if scene.isClickConsumed then
            isConsumed = true
        end
    end
end

function love.mousemoved(x, y, dx, dy)
    local isConsumed = false
    for _, scene in sceneLayers:eachInReverseDrawOrder() do
        scene.isHoverConsumed = isConsumed
        local mousePoint = Vector.new(x, y) / scene:getScale() + scene:getViewportPosition()
        local mouseDelta = Vector.new(dx, dy) / scene:getScale()
        scene:onMouseMove(mousePoint.x, mousePoint.y, mouseDelta.x, mouseDelta.y)
        if scene.isHoverConsumed then
            isConsumed = true
        end
    end
end

function love.keypressed(key, scancode)
    local isConsumed = false
    for _, scene in sceneLayers:eachInReverseDrawOrder() do
        scene.isKeyConsumed = isConsumed
        scene:onKeyPress(key, scancode, false)
        if scene.isKeyConsumed then
            isConsumed = true
        end
    end
end

function love.keyreleased(key, scancode)
    for _, scene in sceneLayers:eachInReverseDrawOrder() do
        scene:onKeyPress(key, scancode, true)
    end
end

function love.wheelmoved(x, y)
    for _, scene in sceneLayers:eachInReverseDrawOrder() do
        scene:onScroll(x, y)
    end
end

function love.textinput(text)
    for _, scene in sceneLayers:eachInReverseDrawOrder() do
        scene:onTextInput(text)
    end
end

function love.mousefocus(focus)
    for _, scene in sceneLayers:eachInReverseDrawOrder() do
        scene:onMouseFocus(focus)
    end
end
