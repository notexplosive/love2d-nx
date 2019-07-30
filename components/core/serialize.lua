local Dehydrate = require("nx/template-loader/dehydrate")
local Serialize = {}

registerComponent(Serialize, "Serialize")

function Serialize:awake()
    self.componentListsAtSpawn = {}
    self.prefabTemplateName = nil
    self.prefabArgumentsAtSpawn = nil
end

function Serialize:addComponentList(componentData)
    append(self.componentListsAtSpawn, componentData)
end

function Serialize:setPrefabInfo(prefabName, arguments, reverseEngineerList)
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

function Serialize:getPrefabInfo()
    return self.prefabTemplateName, unpack(self:getPrefabArgumentsAsList())
end

function Serialize:getPrefabArgumentsAsList()
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

function Serialize:getPrefabData()
    return self.prefabTemplateName,self.prefabArguments,self.reverseEngineerList
end

function Serialize:getData()
    return Dehydrate.actorToNode(self.actor)
end

function Serialize:isPrefab()
    return self.prefabTemplateName ~= nil
end

function Serialize:getPrefabInfoFromSpawn()
    return self.prefabTemplateName, unpack(self.prefabArgumentsAtSpawn)
end

-- gale hack?: why would anyone want this?
function Serialize:scrubAwayPrefabness()
    self.prefabTemplateName = nil
end
-- /gale hack

return Serialize
