local Size = {}

function Size.new(width,height)
    local self = newObject(Size)
    self.width = width
    self.height = height
    return self
end

function Size:grow(dx,dy)
    self.width = self.width + dx
    self.height = self.height + dy
end

function Size:wh()
    return self.width,self.height
end

return Size