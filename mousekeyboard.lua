function love.mousepressed(x,y,button)
    gameScene:onClick(x,y,button,false)
end

function love.mousereleased(x,y,button)
    gameScene:onClick(x,y,button,true)
end

function love.mousemoved(x,y,dx,dy)
    
end

function love.keypressed(key,scancode,isRepeat)
    gameScene:onKeyPress(key,scancode,isRepeat)
end