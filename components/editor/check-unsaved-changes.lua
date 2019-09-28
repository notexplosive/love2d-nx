local CheckUnsavedChanges = {}

registerComponent(CheckUnsavedChanges, "CheckUnsavedChanges", {"FileSystem", "MapFile"})

function CheckUnsavedChanges:awake()
    self.isUnsaved = false
end

function CheckUnsavedChanges:draw(x, y)
    if self.isUnsaved and DEBUG then
        local rect = Rect.new(0, 0, love.graphics.getDimensions())
        rect:inflate(-10, -10)
        love.graphics.setColor(1, 1, 0)
        love.graphics.rectangle("line", rect:xywh())
        love.graphics.printf('Changes are not saved', 0, 10, love.graphics.getWidth() - 15, 'right')
    end
end

function CheckUnsavedChanges:update(dt)
    local currentJson = self.actor.MapFile:getSceneJson()
    local diskJson = self.actor.FileSystem:read("debug.json")

    self.isUnsaved = currentJson ~= diskJson
end

return CheckUnsavedChanges
