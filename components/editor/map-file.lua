local MapFile = {}

registerComponent(MapFile, "MapFile")

local Json = require("nx/json")
local DataLoader = require("nx/template-loader/data-loader")

function MapFile:getSceneData()
    local sceneData = {actors = {}, root = {{}}}
    for i, actor in gameScene:eachActorWith(Components.EditorSerializable) do
        local actorData = {
            components = {{actor.EditorSerializable:getComponentClass().name, actor.EditorSerializable:getArgs()}},
            pos = {actor:pos():xy()},
            angle = actor.EditorSerializable:getAngle()
        }
        if actorData.angle == 0 then
            actorData.angle = nil
        end
        sceneData.actors[i] = actorData
    end
    return sceneData
end

function MapFile:getSceneJson()
    return string.gsub(Json.encode(self:getSceneData()), "},", "},\n")
end

function MapFile:clearActors()
    local oldActors = {}
    for i, actor in gameScene:eachActor() do
        if not actor.Uneditable then
            append(oldActors, actor)
        end
    end

    for i, actor in ipairs(oldActors) do
        actor:destroy()
    end
end

function MapFile:spawnNewActors(newActorDatas)
    for i, actorData in ipairs(newActorDatas) do
        DataLoader.loadActorData(gameScene, actorData)
    end
end

return MapFile
