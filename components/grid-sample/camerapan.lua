local CameraPan = {}

registerComponent(CameraPan,'CameraPan')

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