local Grid = {}

registerComponent(Grid, "Grid")

function Grid:setup(cellWidth, cellHeight)
    self.cellWidth = cellWidth
    self.cellHeight = cellHeight
end

function Grid:snap(actor)
    local p = actor:pos()
    
    p.x = self:roundToNearest(p.x,self.cellWidth)
    p.y = self:roundToNearest(p.y,self.cellHeight)

    actor:setPos(p)
end

function Grid:snapXY(x,y)
    px = self:roundToNearest(x,self.cellWidth)
    py = self:roundToNearest(y,self.cellHeight)

    return px,py
end

function Grid:roundToNearest(v,cellSize)
    local roundUp = false
    if v % cellSize > cellSize/2 then
        roundUp = true
    end

    if roundUp then
        return v - v % cellSize + cellSize
    else
        return v - v % cellSize
    end
end

return Grid
