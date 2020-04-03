local PlayHeadDiscreteIncrements = {}

registerComponent(PlayHeadDiscreteIncrements, "PlayHeadDiscreteIncrements", {"PlayHead"})

function PlayHeadDiscreteIncrements:setup(numberOfIncrements, isOneIndexed)
    self:setNumberOfIncrements(numberOfIncrements or 1)
    self.isOneIndexed = isOneIndexed
end

function PlayHeadDiscreteIncrements:setNumberOfIncrements(numberOfIncrements)
    self.numberOfIncrements = numberOfIncrements
end

function PlayHeadDiscreteIncrements:getNormalizedIncrementSize()
    return 1 / self.numberOfIncrements
end

function PlayHeadDiscreteIncrements:getCurrentIncrement()
    return math.floor(self.actor.PlayHead:getPercent() * self.numberOfIncrements) + self:getOneIfOneIndexed()
end

function PlayHeadDiscreteIncrements:getOneIfOneIndexed()
    if self.isOneIndexed == true then
        return 1
    end

    return 0
end

return PlayHeadDiscreteIncrements
