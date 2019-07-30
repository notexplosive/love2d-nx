local Serializable = {}

registerComponent(Serializable, "Serializable")

function Serializable:awake()
    self.componentListsAtSpawn = {}
    self.prefabTemplateName = nil
    self.prefabArgumentsAtSpawn = nil
end

function Serializable:addComponentList(componentData)
    append(self.componentListsAtSpawn, componentData)
end

function Serializable:setPrefabInfo(prefabName, arguments, templatedVarsList)
    self.prefabTemplateName = prefabName
    self.prefabArgumentsAtSpawn = arguments
    self.templatedVarsList = templatedVarsList

    if templatedVarsList then
        assert(
            type(templatedVarsList) == "table",
            "templatedVarsList is " .. type(templatedVarsList) .. ", should be a table"
        )
    end
end

function Serializable:getPrefabInfo()
    return self.prefabTemplateName, unpack(self:getPrefabArgumentsAsList())
end

function Serializable:getPrefabArgumentsAsList()
    local prefabArguments = {}
    for i, node in ipairs(self.templatedVarsList or {}) do
        local componentName = node[1]
        local index = node[2]
        assert(self.actor[componentName], "Actor needs " .. componentName .. " in order to getPrefabInfo()")
        assert(self.actor[componentName].reverseSetup, componentName .. " needs to implement a reverseSetup() method")

        local reverseSetupResults = {self.actor[componentName]:reverseSetup()}
        append(prefabArguments, reverseSetupResults[index])
    end

    return prefabArguments
end

function Serializable:getPrefabData()
    return self.prefabTemplateName,self.prefabArguments,self.templatedVarsList
end

function Serializable:isPrefab()
    return self.prefabTemplateName ~= nil
end

function Serializable:getPrefabInfoFromSpawn()
    return self.prefabTemplateName, unpack(self.prefabArgumentsAtSpawn)
end

function Serializable:scrubAwayPrefabness()
    self.prefabTemplateName = nil
end

function Serializable.createActorNode(actor)
    local newComponentLists = {}

    for i, componentList in ipairs(actor.Serializable.componentListsAtSpawn) do
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

return Serializable
