local SnapToGrid = {}

registerComponent(SnapToGrid, "SnapToGrid")

function SnapToGrid:setup(gridComponent)
    self.gridComponent = gridComponent
end

function SnapToGrid:update(dt)
    self.gridComponent:snapActor(self.actor)
end

return SnapToGrid
