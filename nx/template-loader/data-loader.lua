local Json = require("nx/json")

local DataLoader = {}

function DataLoader.loadTemplateFile(path, args)
    if args and type(args) ~= "table" then
        assert(false, 'arguments passed to a prefab must be an array "' .. args .. '" -> ["' .. args .. '"]')
    end

    local json = love.filesystem.read(path)
    assert(json, "Cannot find json file " .. path)
    local data = Json.decode(json)

    -- Traverse components of json file, replace _#_ with arguments
    local numberOfArgsLeft = 0
    if args then
        numberOfArgsLeft = DataLoader.replaceUnderscoresWithValues(data, args)
    end

    if data.settings and data.settings.allParamsMustBeFilled then
        assert(
            numberOfArgsLeft == 0,
            "Template " .. path .. " takes " .. numberOfArgsLeft .. " more argument(s) that are not filled"
        )
    end

    DataLoader.replaceUnderscoresWithNils(data)

    return data
end

function DataLoader.replaceUnderscoresWithNils(data)
    local componentLists = data.components
    for j, componentList in ipairs(componentLists or {}) do
        for i, _ in ipairs(componentList) do
            if type(componentList[i]) == "string" then
                local underscoreStr = string.gsub(string.match(componentList[i], "_%d+_") or "", "_", "")
                local underscoreIndex = tonumber(underscoreStr)
                if underscoreIndex then
                    data.components[j][i] = nil
                end
            end
        end
    end
end

function DataLoader.replaceUnderscoresWithValues(data, args)
    local numberOfArgsLeft = #args

    local componentLists = data.components
    for j, componentList in ipairs(componentLists or {}) do
        for i, _ in ipairs(componentList) do
            if type(componentList[i]) == "string" then
                local underscoreStr = string.gsub(string.match(componentList[i], "_%d+_") or "", "_", "")
                local underscoreIndex = tonumber(underscoreStr)
                local arg = args[underscoreIndex]
                if underscoreIndex and arg then
                    data.components[j][i] = arg
                    local componentName = data.components[j][1]
                    local indexInComponent = i - 1
                    data.templatedVarsList = data.templatedVarsList or {}
                    append(data.templatedVarsList, {componentName, indexInComponent})
                    numberOfArgsLeft = numberOfArgsLeft - 1
                end
            end
        end
    end

    if numberOfArgsLeft < 0 then
        numberOfArgsLeft = 0
    end

    return numberOfArgsLeft
end

function DataLoader.loadComponentListData(actor, componentList)
    local skippedComponentLists = {}
    for i, componentData in ipairs(componentList or {}) do
        local componentName = componentData[1]
        local componentClass = Components[componentName]
        assert(componentName, "Nil component name, maybe your json is wrong?")
        assert(componentClass, componentName .. " is not a component")
        local component = actor:addComponent(componentClass)
        local params = {}

        for j = 2, #componentData do
            params[j - 1] = componentData[j]
        end

        if component.setup and #params > 0 then
            actor[componentName]:setup(unpack(params))
        end

        actor.Serializable:addComponentList(componentData)
    end
end

function DataLoader.loadActorData(scene, actorData, prefabName, prefabArguments, prefabTemplatedVars)
    local actor = scene:addActor(actorData.name or "ACTOR" .. love.math.random(899) + 100)

    if prefabName then
        actor.Serializable:setPrefabInfo(prefabName, prefabArguments, prefabTemplatedVars)
    end

    if actorData.pos then
        assert(#actorData.pos == 2, "pos should be two numbers: [x,y]")
        actor:setPos(tonumber(actorData.pos[1]), tonumber(actorData.pos[2]))
    end

    if actorData.angle then
        assert(tonumber(actorData.angle), "Angle should be a number")
        actor:setAngle(tonumber(actorData.angle) * math.pi / 180)
    end

    DataLoader.loadComponentListData(actor, actorData.components)

    return actor
end

function DataLoader.loadPrefabData(scene, nodeData)
    assert(nodeData.prefab, "Attempted to load prefab data on something that was not a prefab")
    local prefabData = DataLoader.loadTemplateFile("prefabs/" .. nodeData.prefab .. ".json", nodeData.arguments)

    if nodeData.name then
        prefabData.name = nodeData.name
    end

    if nodeData.pos then
        prefabData.pos = nodeData.pos
    end

    if nodeData.angle then
        prefabData.angle = nodeData.angle
    end

    local componentCount = #prefabData.components
    for i, componentData in ipairs(nodeData.components or {}) do
        prefabData.components[componentCount + i] = componentData
    end

    return DataLoader.loadActorData(
        scene,
        prefabData,
        nodeData.prefab,
        nodeData.arguments,
        prefabData.templatedVarsList
    )
end

return DataLoader
