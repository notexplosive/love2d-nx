function love.update(dt)
    if firstUpdate then
        firstUpdate(dt)
    end

    if lastUpdate then
        lastUpdate(dt)
    end
end

function love.draw()
    if firstDraw then
        firstDraw()
    end

    if lastDraw then
        lastDraw()
    end
end
