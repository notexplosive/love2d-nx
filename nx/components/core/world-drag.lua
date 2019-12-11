local WorldDrag = {}

registerComponent(WorldDrag, "WorldDrag")

function WorldDrag:awake()
    local size = 500
    self.actor:addComponent(Components.BoundingBox, size, size, size / 2, size / 2)
    self.actor:addComponent(Components.FollowMouse)
    self.actor:addComponent(Components.Hoverable)
    self.actor:addComponent(Components.Clickable)
    self.actor:addComponent(Components.Draggable)
end

function WorldDrag:update()
    if self.startedDrag then
        self.trulyStartedDrag = true
    end
end

function WorldDrag:Draggable_onDragEnd(x, y)
    for j, scene in eachSceneDrawOrder() do
        for i, actor in scene:eachActorWith(Components.WorldDragListener) do
            actor.WorldDragListener:release()
        end
    end
    self:restoreMousePos()
end

function WorldDrag:Draggable_onDrag(x, y, nx, ny, dx, dy)
    local deltaDrag = Vector.new(nx, ny) - self.startPos
    if self.trulyStartedDrag then
        for j, scene in eachSceneDrawOrder() do
            for i, actor in scene:eachActorWith(Components.WorldDragListener) do
                actor.WorldDragListener:setDragVector(deltaDrag)
            end
        end
    end
end

function WorldDrag:onMousePress(x, y, button, wasRelease)
    if button == 1 then
        self.startedDrag = not wasRelease
        self.trulyStartedDrag = false
    end
end

function WorldDrag:Draggable_onDragStart(x, y)
    self:saveMousePos()
    local center = (Vector.new(love.graphics.getDimensions()) / 2)
    if not gameScene:getFirstBehavior(Components.EditMode) then
        love.mouse.setPosition(center:xy())
    end
    self.startPos = center
end

function WorldDrag:saveMousePos()
    self.oldMousePos = Vector.new(love.mouse.getPosition())
end

function WorldDrag:restoreMousePos()
    if self.oldMousePos then
        local center = (Vector.new(love.graphics.getDimensions()) / 2)
        if not gameScene:getFirstBehavior(Components.EditMode) then
            love.mouse.setPosition(center:xy())
        end
        self.oldMousePos = nil
    end
end

return WorldDrag
