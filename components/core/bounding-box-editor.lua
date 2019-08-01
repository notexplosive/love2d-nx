local BoundingBoxEditor = {}

registerComponent(BoundingBoxEditor, "BoundingBoxEditor", {"BoundingBox"})

function BoundingBoxEditor:awake()
    self.sideGrabHandleRects = {}
    self.cornerGrabHandleRects = {}
    self.selectedIndex = nil
    self.grabHandleWidth = 10
end

function BoundingBoxEditor:update(dt)
    local width = self.actor.BoundingBox:width()
    local height = self.actor.BoundingBox:height()

    self.sideGrabHandleRects = {
        self:getTopGrabHandleRect(),
        self:getBottomGrabHandleRect(),
        self:getLeftGrabHandleRect(),
        self:getRightGrabHandleRect()
    }

    self.cornerGrabHandleRects = {
        self:getTopLeftGrabHandleRect(),
        self:getTopRightGrabHandleRect(),
        self:getBottomRightGrabHandleRect(),
        self:getBottomLeftGrabHandleRect()
    }
end

function BoundingBoxEditor:onMouseMove(x, y, dx, dy)
    if self.selectedIndex then
        if self.selectedIndex == 1 or self.selectedIndex == 6 or self.selectedIndex == 5 then
            self.actor:setPos(self.actor:pos() + Vector.new(0, dy))
            self.actor.BoundingBox.size.height = self.actor.BoundingBox:height() - dy
        end
        if self.selectedIndex == 2 or self.selectedIndex == 7 or self.selectedIndex == 8 then
            self.actor.BoundingBox.size.height = self.actor.BoundingBox:height() + dy
        end
        if self.selectedIndex == 3 or self.selectedIndex == 5 or self.selectedIndex == 8 then
            self.actor:setPos(self.actor:pos() + Vector.new(dx, 0))
            self.actor.BoundingBox.size.width = self.actor.BoundingBox:width() - dx
        end
        if self.selectedIndex == 4 or self.selectedIndex == 6 or self.selectedIndex == 7 then
            self.actor.BoundingBox.size.width = self.actor.BoundingBox:width() + dx
        end

        self.actor:callForAllComponents("BoundingBoxEditor_onResize")
    end
end

function BoundingBoxEditor:onMousePress(x, y, button, wasRelease, isClickConsumed)
    if button == 1 and not wasRelease and not isClickConsumed then
        if not self.actor.BoundingBox:getRect():isVectorWithin(x, y) then
            for i, rect in ipairs(self.cornerGrabHandleRects) do
                if rect:isVectorWithin(x, y) then
                    self.selectedIndex = i + 4
                    self.actor:scene():consumeClick()
                    return
                end
            end
        end

        for i, rect in ipairs(self.sideGrabHandleRects) do
            if rect:isVectorWithin(x, y) then
                self.selectedIndex = i
                self.actor:scene():consumeClick()
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

function BoundingBoxEditor:getTopLeftGrabHandleRect()
    local boundingRect = self.actor.BoundingBox:getRect()
    local x = boundingRect:x() - self.grabHandleWidth
    local y = boundingRect:y() - self.grabHandleWidth
    return Rect.new(x, y, self.grabHandleWidth * 2, self.grabHandleWidth * 2)
end

function BoundingBoxEditor:getTopRightGrabHandleRect()
    local boundingRect = self.actor.BoundingBox:getRect()
    local x = boundingRect:x() - self.grabHandleWidth + boundingRect:width()
    local y = boundingRect:y() - self.grabHandleWidth
    return Rect.new(x, y, self.grabHandleWidth * 2, self.grabHandleWidth * 2)
end

function BoundingBoxEditor:getBottomRightGrabHandleRect()
    local boundingRect = self.actor.BoundingBox:getRect()
    local x = boundingRect:x() - self.grabHandleWidth + boundingRect:width()
    local y = boundingRect:y() - self.grabHandleWidth + boundingRect:height()
    return Rect.new(x, y, self.grabHandleWidth * 2, self.grabHandleWidth * 2)
end

function BoundingBoxEditor:getBottomLeftGrabHandleRect()
    local boundingRect = self.actor.BoundingBox:getRect()
    local x = boundingRect:x() - self.grabHandleWidth
    local y = boundingRect:y() - self.grabHandleWidth + boundingRect:height()
    return Rect.new(x, y, self.grabHandleWidth * 2, self.grabHandleWidth * 2)
end

function BoundingBoxEditor:getLeftGrabHandleRect()
    local rect = self.actor.BoundingBox:getRect()
    rect.size.width = self.grabHandleWidth
    rect.pos.x = rect.pos.x - rect.size.width
    return rect
end

function BoundingBoxEditor:getRightGrabHandleRect()
    local rect = self.actor.BoundingBox:getRect()
    rect.pos.x = rect.pos.x + rect.size.width
    rect.size.width = self.grabHandleWidth
    return rect
end

function BoundingBoxEditor:getBottomGrabHandleRect()
    local rect = self.actor.BoundingBox:getRect()
    rect.pos.y = rect.pos.y + rect.size.height
    rect.size.height = self.grabHandleWidth
    return rect
end

function BoundingBoxEditor:getTopGrabHandleRect()
    local rect = self.actor.BoundingBox:getRect()
    rect.size.height = self.grabHandleWidth
    rect.pos.y = rect.pos.y - rect.size.height
    return rect
end

return BoundingBoxEditor
