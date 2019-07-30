local Dehydrate = require("nx/template-loader/dehydrate")
local ActorData = {}

registerComponent(ActorData, "ActorData")

function ActorData:awake()
    self.componentListsAtSpawn = {}
    self.prefabTemplateName = nil
    self.prefabArgumentsAtSpawn = nil
end

function ActorData:addComponentList(componentData)
    append(self.componentListsAtSpawn, componentData)
end

function ActorData:setPrefabInfo(prefabName, arguments, reverseEngineerList)
    self.prefabTemplateName = prefabName
    self.prefabArgumentsAtSpawn = arguments
    self.reverseEngineerList = reverseEngineerList

    if reverseEngineerList then
        assert(
            type(reverseEngineerList) == "table",
            "reverseEngineerList is " .. type(reverseEngineerList) .. ", should be a table"
        )
    end
end

function ActorData:getPrefabInfo()
    return self.prefabTemplateName, unpack(self:getPrefabArgumentsAsList())
end

function ActorData:getPrefabArgumentsAsList()
    local prefabArguments = {}
    for i, node in ipairs(self.reverseEngineerList or {}) do
        local componentName = node[1]
        local index = node[2]
        assert(self.actor[componentName], "Actor needs " .. componentName .. " in order to getPrefabInfo()")
        assert(self.actor[componentName].reverseSetup, componentName .. " needs to implement a reverseSetup() method")

        local reverseSetupResults = {self.actor[componentName]:reverseSetup()}
        append(prefabArguments, reverseSetupResults[index])
    end

    return prefabArguments
end

function ActorData:getPrefabData()
    return self.prefabTemplateName,self.prefabArguments,self.reverseEngineerList
end

function ActorData:getData()
    return Dehydrate.actorToNode(self.actor)
end

function ActorData:isPrefab()
    return self.prefabTemplateName ~= nil
end

function ActorData:getPrefabInfoFromSpawn()
    return self.prefabTemplateName, unpack(self.prefabArgumentsAtSpawn)
end

-- gale hack?: why would anyone want this?
function ActorData:scrubAwayPrefabness()
    self.prefabTemplateName = nil
end
-- /gale hack

return ActorData
