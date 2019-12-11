local MoveTowards = {}

registerComponent(MoveTowards, "MoveTowards")

function MoveTowards:setup(destination)
    self.destination = destination:clone()
end

function MoveTowards:update(dt)
    local dir = self.destination - self.actor:pos()
    local move = dir * 0.25

    self.actor:move(move * dt * 60)

    if move:length() < 1 then
        self.actor:setPos(self.destination)
        self.actor:callForAllComponents("MoveTowards_onArrive")
    end
end

return MoveTowards
