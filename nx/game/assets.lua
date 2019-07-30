-- TODO: add sound assets
local Json = require("nx/json")
local Sprite = require('nx/game/assets/sprite')
local Sound = require('nx/game/assets/sound')

local Assets = {}

function SpritesFromTemplate(path)
    local table = {}
    local data = Json.decode(love.filesystem.read(path))

    for i,name in ipairs(getKeys(data)) do
        local parameters = data[name]
        local sprite = Sprite.new('images/'..parameters[1],parameters[2],parameters[3])

        if parameters[4] then
            for j,animName in ipairs(getKeys(parameters[4])) do
                animParams = parameters[4][animName]
                sprite:createAnimation(animName,animParams[1],animParams[2])
            end
        end

        table[name] = sprite
    end
    return table
end

function SoundsFromTemplate(path)
    local table = {}
    local data = Json.decode(love.filesystem.read(path))

    for i,name in ipairs(getKeys(data)) do
        local parameters = data[name]
        parameters[1] = 'sounds/'..parameters[1]
        local sound = Sound.new(unpack(parameters))
        table[name] = sound
    end
    return table
end

Assets['images'] = SpritesFromTemplate('assets/images.json')
Assets['sounds'] = SoundsFromTemplate('assets/sounds.json')

return Assets