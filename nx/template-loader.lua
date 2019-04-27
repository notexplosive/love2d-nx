local Json = require("nx/json")
local Scene = require("nx/game/scene")

function loadTemplateFile(path,args)
    local json = love.filesystem.read(path)

    for i, arg in ipairs(args or {}) do
        json = string.gsub(json, '"_"', '"' .. arg .. '"', 1)
    end

    -- nil out remaining, json:null -> lua:nil
    local _, count = string.gsub(json, '"_"', "null")
    print(path .. ":", json)

    local data = Json.decode(json)

    if data.settings and data.settings.allParamsMustBeFilled then
        assert(count == 0, "Template " .. path .. " takes an argument that is not filled")
    end

    return data
end

function loadComponentListData(actor, componentList)
    for i, componentData in ipairs(componentList or {}) do
        local componentName = componentData[1]
        local component = actor:addComponent(Components[componentName])
        local params = {}

        for j = 2, #componentData do
            params[j - 1] = componentData[j]
        end

        if component.setup and #params > 0 then
            actor[componentName]:setup(unpack(params))
        end
    end
end

function loadActorData(scene, actorData)
    local actor = scene:addActor(actorData.name or "ACTOR" .. love.math.random(899) + 100)

    if actorData.pos then
        assert(#actorData.pos == 2, "pos should be two numbers: [x,y]")
        actor:setPos(unpack(actorData.pos))
    end

    loadComponentListData(actor, actorData.components)
    return actor
end

function loadPrefabData(scene, nodeData)
    local prefabData = loadTemplateFile('prefabs/'..nodeData.prefab..'.json',nodeData.arguments)

    -- Prefer name provided on the node, otherwise use prefab's default name.
    -- If no name is provided, one will be generated.
    if nodeData.name then
        prefabData.name = nodeData.name
    elseif prefabData.name then
        prefabData.name = prefabData.name
    end

    if nodeData.pos then
        prefabData.pos = nodeData.pos
    end

    return loadActorData(scene, prefabData)
end

function loadSceneData(sceneData)
    local scene = Scene.new()

    if sceneData.dimensions then
        assert(#sceneData.dimensions == 2, "Dimensions should be two numbers: [x,y]")
        scene:setDimensions(unpack(sceneData.dimensions))
    end

    -- Root is just an actor with components just like anybody else.
    -- Root will be at 0,0 and can technically be reassigned although probably shouldn't.
    if sceneData.root then
        local actor = scene:addActor("root")
        loadComponentListData(actor, sceneData.root)
    end

    if sceneData.actors then
        for i, actorData in ipairs(sceneData.actors) do
            if actorData.prefab then
                loadPrefabData(scene, actorData)
            else
                loadActorData(scene, actorData)
            end
        end
    end

    return scene
end

-- Takes a path and then any number of arguments that are slotted into the underscores
function loadScene(path, ...)
    local args = {...}
    local sceneData = loadTemplateFile("scenes/" .. path .. ".json",args)

    local scene = loadSceneData(sceneData)

    return scene
end
