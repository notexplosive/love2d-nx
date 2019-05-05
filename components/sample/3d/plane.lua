local Plane = {}

registerComponent(Plane, "Plane")

function Plane:awake()
    
end

function Plane:draw(x, y)
    local top,left = projectToScreenCoordinates(x,y,10)
    local bottom,right = projectToScreenCoordinates(x+64,y+64,10)

    love.graphics.circle('line', top, left, 10)
    love.graphics.circle('line', bottom, right, 10)

    local top,left = projectToScreenCoordinates(x,y,20)
    local bottom,right = projectToScreenCoordinates(x+64,y+64,20)

    love.graphics.circle('line', top, left, 10)
    love.graphics.circle('line', bottom, right, 10)
end

function Plane:drawHorizontal(x, y, points)
    
end

function Plane:drawVertical(x, y, points)

end

return Plane
