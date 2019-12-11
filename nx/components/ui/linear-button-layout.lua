local LinearButtonLayout = {}

registerComponent(LinearButtonLayout,'LinearButtonLayout')

function LinearButtonLayout:setup(orientation)
    self.orientation = orientation
    self.padding = 5
end

function LinearButtonLayout:start()
    local actors = self.actor:scene():getAllActorsWithBehavior(Components.CommandOnClick)
    for i,actor in ipairs(actors) do
        if i == 1 then
            actor:setPos(self.actor:pos())
        else
            local offset = Vector.new(actors[i-1].BoundingBox:width() + self.padding,0)
            if self.orientation == 'vertical' then
                offset = Vector.new(0,actors[i-1].BoundingBox:height() + self.padding)
            end
            actor:setPos(actors[i-1]:pos() + offset )
        end
    end
end

function LinearButtonLayout:draw(x,y)
    
end

function LinearButtonLayout:update(dt)
    
end

return LinearButtonLayout