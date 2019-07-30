local DataLoader = require("nx/template-loader/data-loader")
local Json = require("nx/json")
local Scene = require("nx/game/scene")

-- temporary workaround that will probably be here forever.
function loadActorData(...)
    return DataLoader.loadActorData(...)
end