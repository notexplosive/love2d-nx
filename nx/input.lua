function love.mousepressed(x, y, button)
    uiScene:onMousePress(x, y, button, false)
    if not uiScene.isClickConsumed then
        gameScene:onMousePress(x, y, button, false)
    end
end

function love.mousereleased(x, y, button)
    uiScene:onMousePress(x, y, button, true)
    if not uiScene.isClickConsumed then
        gameScene:onMousePress(x, y, button, true)
    end
end

function love.mousemoved(x, y, dx, dy)
    uiScene:onMouseMove(x, y, dx, dy)
    gameScene:onMouseMove(x, y, dx, dy)
end

function love.keypressed(key, scancode)
    uiScene:onKeyPress(key, scancode, false)
    gameScene:onKeyPress(key, scancode, false)
end

function love.keyreleased(key, scancode)
    uiScene:onKeyPress(key, scancode, true)
    gameScene:onKeyPress(key, scancode, true)
end

function love.wheelmoved(x, y)
    uiScene:onScroll(x, y)
    gameScene:onScroll(x, y)
end

function love.textinput(text)
    uiScene:onTextInput(text)
    gameScene:onTextInput(text)
end

function love.mousefocus(focus)
    uiScene:onMouseFocus(focus)
    gameScene:onMouseFocus(focus)
end
