local Json = require('nx/json')
local Actor = require('nx/game/actor')

-- Mutates a scene into the result of a template
-- TODO: rewrite this
function SceneFromTemplate(scene,path)
    local data = readJson(path)
    
    local sceneProperties = getKeys(data)
    for i,prop in ipairs(sceneProperties) do
        local val = data[prop]
        if scene.window[prop] ~= nil then
            -- If it's a primitive then assign it
            -- If it's a method then run it with given parameter list
            if type(scene.window[prop]) == 'function' then
                scene.window[prop](scene.window,unpack(val))
            else
                scene.window[prop] = val
            end
        end

        if scene[prop] then
            scene[prop] = val
        end
    end

    local actorList = data.Actors
    for j,actorClump in ipairs(actorList) do
        local actorNames = getKeys(actorClump)
        for i,actorName in ipairs(actorNames) do
            local actor = Actor.new( actorName )
            local properties = actorClump[actorName]
            scene:addActor(actor)
            _applyActorProperties(actor,properties,path)
        end
    end
end

function SpritesFromTemplate(path)
    local data = readJson(path)

    for i,name in ipairs(getKeys(data)) do
        local parameters = data[name]
        local sprite = Sprite.new('images/'..parameters[1],parameters[2],parameters[3])

        if parameters[4] then
            for j,animName in ipairs(getKeys(parameters[4])) do
                animParams = parameters[4][animName]
                sprite:createAnimation(animName,animParams[1],animParams[2])
            end
        end

        Assets[name] = sprite
    end
end

function readJson(path)
    assert(love.filesystem.getInfo(path) and love.filesystem.getInfo(path).type == 'file','File not found '.. path)
    local rawText = love.filesystem.read(path)
    return Json.decode(rawText)
end

-- INTERNAL
function _applyActorProperties(actor,properties,path)
    for j,propName in ipairs(getKeys(properties)) do
        local propVal = properties[propName]
        if propName == 'pos' then
            assert(#propVal == 2,"Position must take two parameters\n"..path)
            actor:setLocalPos(propVal[1],propVal[2])
        elseif propName == 'star' then
            actor.star = true
        end
    end

    -- Now we loop again because pos,star, and other special fields are already set
    for j,propName in ipairs(getKeys(properties)) do
        if propName ~= 'pos' and propName ~= 'star' then
            assert(nx_Components[propName],propName .. ' is not a registered component\n'..path)
            local comp = actor:addComponent(nx_Components[propName])
            if properties[propName] and comp.setup then
                comp:setup(unpack(properties[propName]))
            end
        end
    end
end