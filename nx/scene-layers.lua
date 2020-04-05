local Scene = require("nx/game/scene")
local List = require("nx/list")

local sceneLayers = List.new(Scene)

function sceneLayers:eachInDrawOrder()
    return self:each()
end

function sceneLayers:eachInReverseDrawOrder()
    return self:eachReversed()
end

-- Tests
local Test = require("nx/test")
Test.run(
    "SceneLayers",
    function()
    end
)

-- Singleton!
return sceneLayers
