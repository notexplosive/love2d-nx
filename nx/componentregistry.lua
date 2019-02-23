-- THIS FILE CALLS require() ON ALL COMPONENTS

-- Nx components
SpriteRenderer = require('nx/game/components/spriterenderer')
Physics = require('nx/game/components/physics')
CustomRenderer = require('nx/game/components/customrenderer')
CircleCollider = require('nx/game/components/circlecollider')
TextRenderer = require('nx/game/components/textrenderer')
TileMapRenderer = require('nx/game/components/tilemaprenderer')
TileMap = require('nx/game/components/tilemap')

-- Nx asset objects
Sprite = require('nx/game/assets/sprite')

-- Userdata components
function requireComponents(path)
    for i,v in ipairs(love.filesystem.getDirectoryItems(path)) do
        local filename = path..v
        if love.filesystem.getInfo(filename).type == 'file' then
            name = filename:split('.')[1]
            require(name)
        else
            -- Directory
            requireComponents(filename..'/')
        end
    end
end

requireComponents('components/')