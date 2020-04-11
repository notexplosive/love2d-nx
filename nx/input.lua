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
    sceneLayers:onKeyPress(key, scancode, false)
end

function love.keyreleased(key, scancode)
    sceneLayers:onKeyPress(key, scancode, true)
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
