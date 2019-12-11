local ReloadScene = {}

registerComponent(ReloadScene, "ReloadScene")

function ReloadScene:setup(keybind)
    self.keybind = keybind
end

function ReloadScene:reverseSetup()
    return self.keybind
end

function ReloadScene:start()
    assert(self.keybind)
end

function ReloadScene:onKeyPress(key, scancode, wasRelease)
    if key == self.keybind and not wasRelease then
        local mapFile = uiScene:getFirstBehavior(Components.MapFile)
        local newActorDatas = mapFile:getSceneData().actors
        
        mapFile:clearActors()
        mapFile:spawnNewActors(newActorDatas)
    end
end

return ReloadScene
