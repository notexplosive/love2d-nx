local ArrangeGroupInGrid = {}

registerComponent(ArrangeGroupInGrid, "ArrangeGroupInGrid",{"GroupHelpers"})
-- TODO: this is currently screen-size specific, consider what to do about that?

function ArrangeGroupInGrid:setup(groupName, rowWidth)
    self.groupName = groupName
    self.rowWidth = rowWidth or 3
end

function ArrangeGroupInGrid:start()
    assert(self.groupName, "ArrangeGroupInGrid needs to run setup")
end

function ArrangeGroupInGrid:update(dt)
    local actors = self.actor.GroupHelpers:getGroup(self.groupName)
    local count = #actors

    local row, col = 0, 0
    for i = 1, count do
        if col > self.rowWidth - 1 then
            col = 0
            row = row + 1
        end
        actors[i]:setPos(
            Vector.new(col * actors[i].BoundingBox.width, row * actors[i].BoundingBox.height) * 1.2 + self.actor:pos()
        )
        col = col + 1
    end
end

return ArrangeGroupInGrid
