local Serializable = {}

registerComponent(Serializable, "Serializable")

function Serializable:awake()
    self.componentListsAtSpawn = {}
end

function Serializable:addComponentList(componentData)
    append(self.componentListsAtSpawn, componentData)
end

function Serializable:createActorNode()
    local actor = self.actor
    local newComponentLists = {}

    for i, componentList in ipairs(actor.Serializable.componentListsAtSpawn) do
        local componentName = componentList[1]
        if actor[componentName].reverseSetup then
            newComponentLists[i] = {componentName, actor[componentName]:reverseSetup()}
        else
            newComponentLists[i] = copyList(componentList)
        end
    end

    -- gale hack: until we move this component into nx
    if actor.PreserveTransform then
        actor.PreserveTransform:load()
    end
    -- /gale hack

    local actorXY = {actor:pos():xy()}
    if actorXY[1] == 0 and actorXY[2] == 0 then
        actorXY = nil
    end

    local actorAngle = actor:angle() * 180 / math.pi

    if actorAngle == 0 then
        actorAngle = nil
    end

    return {
        pos = actorXY,
        angle = actorAngle,
        components = newComponentLists,
        name = actor.name
    }
end

return Serializable
