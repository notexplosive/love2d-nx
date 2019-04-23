local TileMapRenderer = {}

registerComponent(TileMapRenderer,"TileMapRenderer")

function TileMapRenderer.create()
    return newObject(TileMapRenderer)
end

function TileMapRenderer:init(spriteName, scale, color)
    self.spriteAsset = Assets[spriteName]
    if scale then
        self.scale = scale
    end

    if color then
        self.color = color
    end

    self:generateTiles()
end

function TileMapRenderer:awake()
    self.spriteAsset = nil
    self.scale = 1
    self.offset = Vector.new(0, 0)
    self.color = {1,1,1}
end

function TileMapRenderer:newTile(gridX, gridY, frame)
    local adjustedGridX,adjustedGridY = gridX-1,gridY-1
    local tile = {
        gridX = adjustedGridX,
        gridY = adjustedGridY,
        x = adjustedGridX * self.spriteAsset.gridWidth * self.scale,
        y = adjustedGridY * self.spriteAsset.gridHeight * self.scale,
        frame = frame or 1
    }

    return tile
end

function TileMapRenderer:generateTiles()
    self.tiles = {}

    assert(self.spriteAsset)
    local i = 1
    local gridX = 0
    local gridY = 0
    for y = 0, self.actor:scene().height, self.spriteAsset.gridHeight * self.scale do
        gridY = gridY + 1
        gridX = 0
        for x = 0, self.actor:scene().width + self.spriteAsset.gridWidth * self.scale, self.spriteAsset.gridWidth * self.scale do
            gridX = gridX + 1

            self.tiles[i] = self:newTile(gridX, gridY, x, y)
            i = i + 1
        end
    end
end

function TileMapRenderer:draw()
    for i, tile in ipairs(self.tiles) do
        self.spriteAsset:draw(
            tile.frame,
            self.actor.pos.x + tile.x,
            self.actor.pos.y + tile.y,
            math.floor(self.offset.x / self.scale) % self.spriteAsset.gridWidth,
            math.floor(self.offset.y / self.scale) % self.spriteAsset.gridHeight,
            0,
            self.scale,
            self.color
        )
        --love.graphics.print(i+32,tile.x,tile.y)
    end
end

function TileMapRenderer:getGridDimensions()
    return self.spriteAsset.gridWidth * self.scale, self.spriteAsset.gridHeight * self.scale
end

return TileMapRenderer
