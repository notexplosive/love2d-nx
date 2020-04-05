local sceneLayers = require("nx/scene-layers")

function love.mousepressed(x, y, button)
    love.mousemoved(x, y, 0, 0)
    sceneLayers:onMousePress(x, y, button, false)
end

function love.mousereleased(x, y, button)
    love.mousemoved(x, y, 0, 0)
    sceneLayers:onMousePress(x, y, button, true)
end

function love.mousemoved(x, y, dx, dy)
    sceneLayers:onMouseMove(x, y, dx, dy)
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
