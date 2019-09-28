local WorldDragListener = {}

registerComponent(WorldDragListener, "WorldDragListener")

function WorldDragListener:awake()
    self.vector = Vector.new()
end

function WorldDragListener:setDragVector(vector)
    self.vector = vector
end

function WorldDragListener:getDragVector()
    return self.vector:clone()
end

function WorldDragListener:getPercent()
    local maximumLength = 300
    return math.min(self.vector:length(), maximumLength) / maximumLength
end

function WorldDragListener:getAngle()
    if self.vector:length() == 0 then
        return 0
    end
    return self.vector:angle()
end

function WorldDragListener:release()
    self.actor:callForAllComponents('WorldDragListener_onRelease')
    self:setDragVector(Vector.new())
end

return WorldDragListener
