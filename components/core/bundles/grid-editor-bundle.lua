local GridEditorBundle = {}

registerComponent(GridEditorBundle, "GridEditorBundle")

function GridEditorBundle:setup(cellWidth, cellHeight, numberOfCols, numberOfRows)
    self.actor:addComponent(Components.Grid, cellWidth, cellHeight)
    self.actor:addComponent(Components.GridRenderer, numberOfCols, numberOfRows)

    local cursor = self.actor:scene():addActor()
    cursor:addComponent(Components.SetPosToCursor)
    cursor:addComponent(Components.SnapToGrid, self.actor.Grid)
    cursor:addComponent(Components.BoundingBox, cellWidth, cellHeight)
    cursor:addComponent(Components.BoundingBoxRenderer)
    cursor:addComponent(Components.RectRenderer, cellWidth, cellHeight)

    local cursor2 = self.actor:scene():addActor()
    cursor2:addComponent(Components.SetPosToCursor)
    cursor2:addComponent(Components.BoundingBox, cellWidth, cellHeight)
    cursor2:addComponent(Components.BoundingBoxRenderer)
    cursor2:addComponent(Components.RectRenderer, cellWidth, cellHeight)
end

function GridEditorBundle:draw(x, y)
end

function GridEditorBundle:update(dt)
end

return GridEditorBundle
