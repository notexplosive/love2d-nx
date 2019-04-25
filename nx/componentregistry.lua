-- This file handles all component registry

Components = {}
function registerComponent(componentClass,name,deps)
    componentClass.name = componentClass.name or name
    componentClass.dependencies = deps or {}
    print("REGISTERED: " .. componentClass.name)
    
    function componentClass.create()
        return newObject(componentClass)
    end

    function componentClass.destroy(self)
        if self.actor then
            self.actor:removeComponent(componentClass)
        end
    end

    Components[componentClass.name] = componentClass
end

-- Nx components
SpriteRenderer = require('nx/game/components/spriterenderer')
Physics = require('nx/game/components/physics')
TextRenderer = require('nx/game/components/textrenderer')
TileMapRenderer = require('nx/game/components/tilemaprenderer')
TileMap = require('nx/game/components/tilemap')
Layer = require('nx/game/components/layer')
SceneRenderer = require('nx/game/components/scenerenderer')

-- Nx asset classes, these will allow you to use Sprites and Sounds
Sprite = require('nx/game/assets/sprite')

-- Userdata components
function requireComponents(path)
    for i,v in ipairs(love.filesystem.getDirectoryItems(path)) do
        local filename = path..v
        if love.filesystem.getInfo(filename).type == 'file' then
            moduleName = filename:split('.')[1]
            require(moduleName)
        else
            -- Recurse into sub-directory
            requireComponents(filename..'/')
        end
    end
end

-- Recurse into each of these folders and call require() on all of them
requireComponents('components/')