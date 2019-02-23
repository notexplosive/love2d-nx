function love.update(dt)
    if firstUpdate then firstUpdate(dt) end

    for _,obj in ipairs(nx_AllObjects) do
        if obj.updateFunctions then
            for _,func in ipairs(obj.updateFunctions) do
                func(dt)
            end
        end

        if obj.update then
            obj:update(dt)
        end
    end

    if lastUpdate then lastUpdate(dt) end
end

function _mainDraw()
    if firstDraw then firstDraw() end

    for i=#nx_AllDrawableObjects,1,-1 do
        local obj = nx_AllDrawableObjects[i]
        if obj.drawFunctions then
            for _,func in ipairs(obj.drawFunctions) do
                func()
            end
        end

        if obj.draw then
            if obj.pos then
                local dp = getDrawPos(obj.pos)
                obj:draw(dp.x,dp.y)
            else
                obj:draw()
            end
        end
    end

    if lastDraw then lastDraw() end
end

function love.draw()
    _mainDraw()
end
