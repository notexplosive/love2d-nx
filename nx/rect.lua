local Rect = {}

function Rect.new(x,y,width,height)
    local self = newObject(Rect)
    
    self.pos = Vector.new()
    self.width = width
    self.height = height

    return self
end

function Rect:getDimensions()
    return self.width,self.height
end

function Rect:xywh()
    return self.pos.x,self.pos.y,self.width,self.height
end

return Rect