local DataLoader = require("nx/template-loader/data-loader")
local Json = require("nx/json")
local Scene = require("nx/game/scene")

-- Takes a path and then any number of arguments that are slotted into the underscores
function loadScene(path, ...)
    local args = {...}
    local sceneData = DataLoader.loadTemplateFile("scenes/" .. path .. ".json", args)

    local scene = Scene.fromSceneData(sceneData)

    return scene
end

-- temporary workaround that will probably be here forever.
function loadActorData(...)
    return DataLoader.loadActorData(...)
end