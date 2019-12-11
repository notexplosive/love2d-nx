function love.mousepressed(x, y, button)
    love.mousemoved(x, y, 0, 0)
    local isConsumed = false
    for _, scene in eachSceneReverseDrawOrder() do
        scene.isClickConsumed = isConsumed
        scene:onMousePress(x - scene.camera.x, y - scene.camera.y, button, false)
        if scene.isClickConsumed then
            isConsumed = true
        end
    end
end

function love.mousereleased(x, y, button)
    love.mousemoved(x, y, 0, 0)
    local isConsumed = false
    for _, scene in eachSceneReverseDrawOrder() do
        scene.isClickConsumed = isConsumed
        scene:onMousePress(x - scene.camera.x, y - scene.camera.y, button, true)
        if scene.isClickConsumed then
            isConsumed = true
        end
    end
end

function love.mousemoved(x, y, dx, dy)
    local isConsumed = false
    for _, scene in eachSceneReverseDrawOrder() do
        scene.isHoverConsumed = isConsumed
        scene:onMouseMove(x - scene.camera.x, y - scene.camera.y, dx, dy)
        if scene.isHoverConsumed then
            isConsumed = true
        end
    end
end

function love.keypressed(key, scancode)
    for _, scene in eachSceneReverseDrawOrder() do
        scene:onKeyPress(key, scancode, false)
    end
end

function love.keyreleased(key, scancode)
    for _, scene in eachSceneReverseDrawOrder() do
        scene:onKeyPress(key, scancode, true)
    end
end

function love.wheelmoved(x, y)
    for _, scene in eachSceneReverseDrawOrder() do
        scene:onScroll(x, y)
    end
end

function love.textinput(text)
    for _, scene in eachSceneReverseDrawOrder() do
        scene:onTextInput(text)
    end
end

function love.mousefocus(focus)
    for _, scene in eachSceneReverseDrawOrder() do
        scene:onMouseFocus(focus)
    end
end
