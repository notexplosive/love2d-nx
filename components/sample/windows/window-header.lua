local WindowHeader = {}

registerComponent(WindowHeader,'WindowHeader',{"BoundingBox"})

function WindowHeader:awake()
    
end

function WindowHeader:start()
    -- Inherit width from the canvas
    local canvas = self.actor:getChildByName("WindowCanvas")
    if canvas and canvas.BoundingBox then
        self.actor.BoundingBox.width = canvas.BoundingBox.width
        self.actor.BoundingBox.height = 32
    end
end

function WindowHeader:draw(x,y)
    
end

function WindowHeader:update(dt)
    
end

return WindowHeader