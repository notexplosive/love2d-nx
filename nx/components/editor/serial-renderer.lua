local Json = require("nx/json")
local SerialRenderer = {}

registerComponent(SerialRenderer, "SerialRenderer")

function SerialRenderer:draw(x, y)
    love.graphics.setColor(1, 1, 1, 1)
    local nodes = {}
    for i, actor in self.actor:scene():eachActorWith(Components.Serializable) do
        nodes[i] = actor.Serializable:createActorNode()
    end

    local actorNodes = List.new()
    local rootNode = nil
    for i, node in ipairs(nodes) do
        if node.name ~= "root" then
            actorNodes:add(node)
        else
            rootNode = node
        end
    end

    self:cacheJson(actorNodes, rootNode)

    love.graphics.print(self.cachedJson, x, y)
end

function SerialRenderer:cacheJson(actorNodes, rootNode)
    local str = ""
    str = str .. "{\n"

    if rootNode then
        str = str .. '"root": ' .. Json.encode(rootNode) .. ",\n"
    end

    str = str .. '"actors":[\n'
    for i, actorNode in actorNodes:each() do
        str = str .. Json.encode(actorNode) .. ",\n"
    end
    str = str .. "]\n"

    str = str .. "}"

    self.cachedJson = str
end

function SerialRenderer:onApplicationClose()
    if ALLOW_DEBUG then
        print("Serialized a recent json")
        local file = io.open("most_recent_scene.json", "w")
        if file then
            file:write(self.cachedJson)
            file:close()
        end
    end
end

return SerialRenderer
