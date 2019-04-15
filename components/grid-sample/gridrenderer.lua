local GridRenderer = {}

registerComponent(GridRenderer, "GridRenderer")

function GridRenderer:awake()
    self.data = {}
end

function GridRenderer:start()
    self.brush = self.actor:scene():getFirstActorWithBehavior(Components.GridBrush).GridBrush
end

function GridRenderer:draw(x, y, inFocus)
    self.hoveredRect = nil
    for gy = 0, 100 do
        for gx = 0, 100 do
            local fill = "line"
            local mx, my = self.actor:scene():getMousePosition()
            local rectHash = gx .. " " .. gy
            love.graphics.setColor(0.5, 0.5, 0.5)
            if isWithinBox(mx, my, self:getRect(x, y, gx, gy)) and not love.mouse.isDown(3) then
                fill = "fill"
                self.hoveredRect = rectHash
            end

            if self.data[rectHash] then
                love.graphics.setColor(self.brush:getColor(self.data[rectHash]))
                fill = "fill"
            end

            love.graphics.rectangle(fill, self:getRect(x, y, gx, gy))
        end
    end
end

function GridRenderer:update(dt, inFocus)
end

function GridRenderer:getRect(x, y, gx, gy)
    local gridSize = 64
    return gx * gridSize + x, gy * gridSize + y, gridSize, gridSize
end

function GridRenderer:onMousePress(x, y, button, wasRelease)
    if not wasRelease then
        if self.hoveredRect then
            if button == 1 then
                self.data[self.hoveredRect] = self.brush.colorIndex
            end

            if button == 2 then
                self.data[self.hoveredRect] = nil
            end
        end
    end
end

return GridRenderer
