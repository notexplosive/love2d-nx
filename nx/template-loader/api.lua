local DataLoader = require("nx/template-loader/data-loader")
local Dehydrate = require("nx/template-loader/dehydrate")
local Json = require("nx/json")
local Scene = require("nx/game/scene")

-- Takes a path and then any number of arguments that are slotted into the underscores
function loadScene(path, ...)
    local args = {...}
    local sceneData = DataLoader.loadTemplateFile("scenes/" .. path .. ".json", args)

    local scene = DataLoader.loadSceneData(sceneData)

    return scene
end

function loadPrefab(scene, prefabName, ...)
    assert(scene.type and scene:type() == Scene,"first param must be a scene")
    -- Dehydrate the actor to a prefab node
    local nodeData = {
        prefab = prefabName,
        arguments = {...}
    }

    local actor = DataLoader.loadPrefabData(scene, nodeData)

    return actor
end

-- temporary workaround that will probably be here forever.
function loadActorData(...)
    return DataLoader.loadActorData(...)
end