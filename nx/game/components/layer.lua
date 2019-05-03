local Layer = {}

registerComponent(Layer,'Layer')

Layer.total = 0

function Layer.__lt(small,big)
    return small.index < big.index
end

function Layer:awake()
    Layer.total = Layer.total + 1
    self.index = Layer.total
end

function Layer:draw(x,y)
    
end

function Layer:onDestroy()

end

function Layer:getInDrawOrder()
    return copyReversed(self:getInOrder())
end

function Layer:getInOrder()
    local layers = {}
    for i,actor in ipairs(self.actor:scene():getAllActorsWithBehavior(Layer)) do
        if actor.Layer.group == self.group then
            append(layers,actor.Layer)
        end
    end

    table.sort(layers)

    local result = {}
    for i,layer in ipairs(layers) do
        result[i] = layer.actor
    end

    return result
end

function Layer:bringToFront()
    if self.index == 1 then
        return
    end

    local actors = self:getInOrder()
    deleteAt(actors,self.index)
    local oldFront = deleteAt(actors,1)
    oldFront.Layer.index = self.index

    -- Fix layers such that self is in front, oldFront is in second, and everyone else maintains
    -- relative order
    local list = {self.actor,oldFront,unpack(actors)}
    for i,actor in ipairs(list) do
        actor.Layer.index = i
    end

    -- I took the easy way out.
    for i,child in ipairs(self.actor.children or {}) do
        if child.Layer then
            child.Layer:bringToFront()
        end
    end
end

return Layer