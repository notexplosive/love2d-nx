local TileMap = {}

registerComponent(TileMap,"TileMap")

function TileMap.create_object()
    return newObject(TileMap)
end

function TileMap:setup(mapName,posX,posY)
    if mapName then
        self:setupTiles(mapName)
    end

    local gw,gh = self.actor.tileMapRenderer:getGridDimensions()
    self.actor:setLocalPos( posX * gw, posY * gh)
end

function TileMap:awake()
    
end

function TileMap:setupTiles(mapName)
    local renderer = self.actor.tileMapRenderer

    local maps = {
        normalDoor = {
            {150, 151},
            {170, 171},
            {148, 149}
        },

        vendingMachine = {
            {48,49},
            {68,69},
            {88,89}
        },

        wall = {
            {66},
            {66},
            {66},
            {66},
            {66},
            {66},
            {86},
        }
    }

    local map = maps[mapName]
    assert(map, "No map called " .. mapName)

    renderer.tiles = {}

    for gridY, row in ipairs(map) do
        for gridX, id in ipairs(row) do
            local tile = renderer:newTile(gridX, gridY)
            tile.frame = id
            append(renderer.tiles, tile)
        end
    end
end

function TileMap:update(dt)
end

return TileMap
