local EaseTo = {}

registerComponent(EaseTo,'EaseTo')

function EaseTo:setup(v,y)
    self.destination = Vector.new(v,y)
end

function EaseTo:update(dt)
    local mov = (self.destination - self.actor:pos())/4
    self.actor:setPos(self.actor:pos() + mov)

    if mov:length() < 1 then
        self.actor:setPos(self.destination)
        self:destroy()
    end
end

return EaseTo