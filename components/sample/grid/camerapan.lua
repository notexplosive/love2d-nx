local CameraPan = {}

registerComponent(CameraPan,'CameraPan')

function CameraPan:setup(x,y)
    assert(tonumber(x) and tonumber(y),"CameraPan takes 2 numbers")
    self.actor:scene().camera.x = x
    self.actor:scene().camera.y = y
end

function CameraPan:awake()
    self.grabbed = false
end

function CameraPan:draw(x,y)
    
end

function CameraPan:update(dt)
    
end

function CameraPan:onMousePress(x,y,button,wasRelease)
    if button == 3 then
        self.grabbed = not wasRelease
    end
end

function CameraPan:onMouseMove(x,y,dx,dy)
    if self.grabbed then
        self.actor:scene().camera.x = self.actor:scene().camera.x - dx
        self.actor:scene().camera.y = self.actor:scene().camera.y - dy
    end
end

return CameraPan