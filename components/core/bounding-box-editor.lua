local BoundingBoxEditor = {}

registerComponent(BoundingBoxEditor, "BoundingBoxEditor", {"BoundingBox"})

function BoundingBoxEditor:awake()
    self.points = {}
    self.selectedIndex = nil
end

function BoundingBoxEditor:draw(x, y)
    if not self.actor.EditorNode then
        return
    end

    local width = self.actor.BoundingBox.width
    local height = self.actor.BoundingBox.height
    love.graphics.setColor(0.5, 0.5, 1)
    self.points = {
        {x + width / 2, y - 15},
        {x + width / 2, y + height + 15},
        {x - 15, y + height / 2},
        {x + width + 15, y + height / 2}
    }

    if self.actor.Selectable:selected() then
        for i, point in ipairs(self.points) do
            local fill = "line"
            if self.selectedIndex == i then
                fill = "fill"
            end
            love.graphics.circle(fill, point[1], point[2], 10)
        end
    end
end

function BoundingBoxEditor:update(dt)
end

function BoundingBoxEditor:onMouseMove(x, y, dx, dy)
    if self.selectedIndex then
        if self.selectedIndex == 1 then
            self.actor:setPos(self.actor:pos() + Vector.new(0, dy))
            self.actor.BoundingBox.height = self.actor.BoundingBox.height - dy
        end
        if self.selectedIndex == 2 then
            self.actor.BoundingBox.height = self.actor.BoundingBox.height + dy
        end
        if self.selectedIndex == 3 then
            self.actor:setPos(self.actor:pos() + Vector.new(dx, 0))
            self.actor.BoundingBox.width = self.actor.BoundingBox.width - dx
        end
        if self.selectedIndex == 4 then
            self.actor.BoundingBox.width = self.actor.BoundingBox.width + dx
        end

        self.actor:callForAllComponents("onBoundingBoxResize")
    end
end

function BoundingBoxEditor:onMousePress(x, y, button, wasRelease, isClickConsumed)
    if button == 1 and not wasRelease and not isClickConsumed then
        if self.actor.Selectable:selected() then
            for i, point in ipairs(self.points) do
                if (Vector.new(point[1], point[2]) - Vector.new(x, y)):length() < 10 then
                    self.selectedIndex = i
                    self.actor:scene():consumeClick()
                end
            end
        end
    end

    if button == 1 and wasRelease then
        self.selectedIndex = nil
        if self.actor.BoundingBox:getArea() <= 0 then
            self.actor:destroy()
        end
    end
end

return BoundingBoxEditor
