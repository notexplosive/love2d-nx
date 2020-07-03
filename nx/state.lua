local Json = require("nx/json")
State = {}
State.persistedData = {}

function State:load()
    -- moved this out of global space so we don't errantly save a file
    if not love.filesystem.getInfo("savefile") then
        love.filesystem.write("savefile", "")
        State.persistedData = {}
    end

    local text = love.filesystem.read("savefile")

    if text ~= "" then
        local data = Json.decode(text)
        for i, key in ipairs(getKeys(data)) do
            State[key] = data[key]
        end

        self.persistedData = data
    end
end

-- Sets a flag, does not write it to disk
function State:set(flagName, val)
    if val == nil then
        val = true
    end
    State[flagName] = val
end

function State:get(flagName)
    return State[flagName]
end

function State:getBool(flagName)
    if State:get(flagName) == nil then
        return false
    end

    return State:get(flagName)
end

-- Sets a flag and then writes it to disk
function State:persist(flagName, val)
    if val == nil then
        val = true
    end
    State:set(flagName, val)
    self.persistedData[flagName] = val
    love.filesystem.write("savefile", Json.encode(self.persistedData))
end

function State:deleteSave()
    love.filesystem.remove("savefile")
end

State:load()

return State
