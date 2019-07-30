local DrawPos = {}

registerComponent(DrawPos,'DrawPos')

function DrawPos:awake()
    self.pos = Vector.new()
end

function DrawPos:draw(x,y)
    self.pos = Vector.new(x,y)
end

function DrawPos:get()
    return self.pos:clone()
end

return DrawPos