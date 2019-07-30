local Dehydrate = {}

-- Dehydrate down to node
function Dehydrate.actorToNode(actor)
    local newComponentLists = {}

    for i, componentList in ipairs(actor.Serialize.componentListsAtSpawn) do
        local componentName = componentList[1]
        if actor[componentName].reverseSetup then
            newComponentLists[i] = {componentName, actor[componentName]:reverseSetup()}
        else
            newComponentLists[i] = copyList(componentList)
        end
    end

    for i, v in ipairs(newComponentLists) do
        print(unpack(newComponentLists[i]))
    end

    -- gale hack: until we move this component into nx
    if actor.PreserveTransform then
        actor.PreserveTransform:load()
    end
    -- /gale hack

    local actorXY = {actor:pos():xy()}
    local actorAngle = actor:angle() * 180 / math.pi

    return {
        pos = actorXY,
        angle = actorAngle,
        components = newComponentLists,
        name = actor.name
    }
end

return Dehydrate