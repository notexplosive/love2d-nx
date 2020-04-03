local Scene = require("nx/game/scene")
local List = require("nx/list")

local sceneLayers = List.new(Scene)

function sceneLayers:eachInDrawOrder()
    return self:each()
end

function sceneLayers:eachInReverseDrawOrder()
    return self:eachReversed()
end

-- Singleton!
return sceneLayers
