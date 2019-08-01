-- This file handles all component registry

Components = {}
function registerComponent(componentClass, name, deps)
    if deps then
        assert(type(deps) == "table","Dependencies need to be in a table (" ..name..")")
    end
    componentClass.name = componentClass.name or name
    componentClass.dependencies = deps or {}
    print("REGISTERED: " .. componentClass.name)

    function componentClass.create_object()
        return newObject(componentClass)
    end

    function componentClass.destroy(self)
        if self._componentDestroyed then
            return
        end
        if self.actor then
            if self.onDestroy then
                self:onDestroy()
            end
            self.actor:removeComponent(componentClass)
        end
        self._componentDestroyed = true
    end

    Components[componentClass.name] = componentClass
end

-- Nx components
TextRenderer = require("nx/game/components/textrenderer")
TileMapRenderer = require("nx/game/components/tilemaprenderer")
TileMap = require("nx/game/components/tilemap")
SceneRenderer = require("nx/game/components/scenerenderer")

-- Userdata components
function requireComponents(path)
    for i, v in ipairs(love.filesystem.getDirectoryItems(path)) do
        local filename = path .. v
        if love.filesystem.getInfo(filename).type == "file" then
            moduleName = filename:split(".")[1]
            require(moduleName)
        else
            -- Recurse into sub-directory
            requireComponents(filename .. "/")
        end
    end
end

-- Recurse into each of these folders and call require() on all of them
requireComponents("components/")
