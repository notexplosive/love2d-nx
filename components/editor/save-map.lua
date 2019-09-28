local SaveMap = {}

registerComponent(SaveMap,'SaveMap', {"Keybind","MapFile","FileSystem"})

local Json = require("nx/json")

function SaveMap:Keybind_onPress(key)
    if key == '^s' then
        self:save()
    end

    if key == "^l" then
        self:load('debug.json')
    end
end

function SaveMap:save()
    self.actor.FileSystem:write("debug.json", self.actor.MapFile:getSceneJson())
end

function SaveMap:load(fileName)
    local jsonData = self.actor.FileSystem:read(fileName)
    assert(jsonData, "no data at " .. self.actor.FileSystem:getPath(fileName))
    local sceneData = Json.decode(jsonData)
    self.actor.MapFile:clearActors()
    self.actor.MapFile:spawnNewActors(sceneData.actors)
end

return SaveMap