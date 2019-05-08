local WindowCanvas = {}

registerComponent(WindowCanvas,'WindowCanvas', {'BoundingBox'})

function WindowCanvas:awake()
    
end

function WindowCanvas:draw(x,y)
    
end

function WindowCanvas:update(dt)
    
end

function WindowCanvas:onMousePress(x,y,button,wasRelease)
    if button == 1 then
        local inRect = isWithinBox(x,y,self.actor.BoundingBox:getRect())
        if not wasRelease and inRect then
            self._wasClickInitiated = true
        end

        if wasRelease then
            if self._wasClickInitiated and inRect then
                
            end
            self._wasClickInitiated = false
        end
    end
end

return WindowCanvas