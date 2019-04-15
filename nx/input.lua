function love.mousepressed(x,y,button)
    gameScene:onMousePress(x,y,button,false)
end

function love.mousereleased(x,y,button)
    gameScene:onMousePress(x,y,button,true)
end

function love.mousemoved(x,y,dx,dy)
    gameScene:onMouseMove(x,y,dx,dy)
end

function love.keypressed(key,scancode)
    gameScene:onKeyPress(key,scancode,false)
end

function love.keyreleased(key,scancode)
    gameScene:onKeyPress(key,scancode,true)
end

function love.wheelmoved(x,y)
    gameScene:onScroll(x,y)
end