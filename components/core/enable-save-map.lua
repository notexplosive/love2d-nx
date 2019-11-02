local EnableSaveMap = {}

registerComponent(EnableSaveMap, "EnableSaveMap")

function EnableSaveMap:awake()
    self.actor:addComponent(Components.FileSystem, "maps")
    self.actor:addComponent(Components.MapFile)
    self.actor:addComponent(Components.Keybind)
    self.actor:addComponent(Components.SaveMap)
    self.actor:addComponent(Components.CheckUnsavedChanges)
    self.actor:addComponent(Components.AlwaysOnTop)
end

function EnableSaveMap:draw(x, y)
end

function EnableSaveMap:update(dt)
end

return EnableSaveMap
