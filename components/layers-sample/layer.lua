local Layer = {}

registerComponent(Layer,'Layer')

Layer.total = 0

-- TODO: Layer:init(index,group)
-- After we determine what inits are going to look like in the new world

function Layer.__lt(small,big)
    return small.index < big.index
end

function Layer:awake()
    Layer.total = Layer.total + 1
    self.index = Layer.total
    self.group = 'default'
end

function Layer:draw(x,y)
    love.graphics.setColor(1, 1, 1, self.index / self:groupCount() / 2)
    love.graphics.rectangle('fill', self.actor.BoundingBox:getRect())
    love.graphics.print(self.index,x,y)
end

function Layer:groupCount()
    local count = 0
    for i,actor in ipairs(self.actor:scene():getAllActorsWithBehavior(Layer)) do
        if actor.Layer.group == self.group then
            count = count + 1
        end
    end
    return count
end

function Layer:getAllActorsInOrder()
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

    local actors = self:getAllActorsInOrder()
    deleteAt(actors,self.index)
    local oldFront = deleteAt(actors,1)
    oldFront.Layer.index = self.index

    -- Fix layers such that self is in front, oldFront is in second, and everyone else maintains
    -- relative order
    local list = {self.actor,oldFront,unpack(actors)}
    for i,actor in ipairs(list) do
        actor.Layer.index = i
    end
end

return Layer