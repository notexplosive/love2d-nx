local BoundingBoxEditor = {}

registerComponent(BoundingBoxEditor, "BoundingBoxEditor", {"BoundingBox"})

function BoundingBoxEditor:awake()
    self.sideGrabHandleRects = {}
    self.cornerGrabHandleRects = {}
    self.selectedIndex = nil
    self.grabHandleWidth = 10

    self.minimumSize = Size.new(64,64)
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
        local alongTop = self.selectedIndex == 1 or self.selectedIndex == 6 or self.selectedIndex == 5
        local alongBottom = self.selectedIndex == 2 or self.selectedIndex == 7 or self.selectedIndex == 8
        local alongLeft = self.selectedIndex == 3 or self.selectedIndex == 5 or self.selectedIndex == 8
        local alongRight = self.selectedIndex == 4 or self.selectedIndex == 6 or self.selectedIndex == 7

        if alongTop then
            self:moveVerticallyBy(dy)
            self.actor.BoundingBox.size.height = self.actor.BoundingBox:height() - dy
            local overage = math.max(self.minimumSize.height - self.actor.BoundingBox:height(),0)
            self.actor.BoundingBox.size.height = self.actor.BoundingBox:height() + overage
            self:moveVerticallyBy(-overage)
        end

        if alongBottom then
            self.actor.BoundingBox.size.height = self.actor.BoundingBox:height() + dy
            local overage = math.max(self.minimumSize.height - self.actor.BoundingBox:height(),0)
            self.actor.BoundingBox.size.height = self.actor.BoundingBox:height() + overage
        end

        if alongLeft then
            self:moveHorizontallyBy(dx)
            self.actor.BoundingBox.size.width = self.actor.BoundingBox:width() - dx
            local overage = math.max(self.minimumSize.width - self.actor.BoundingBox:width(),0)
            self.actor.BoundingBox.size.width = self.actor.BoundingBox:width() + overage
            self:moveHorizontallyBy(-overage)
        end

        if alongRight then
            self.actor.BoundingBox.size.width = self.actor.BoundingBox:width() + dx
            local overage = math.max(self.minimumSize.width - self.actor.BoundingBox:width(),0)
            self.actor.BoundingBox.size.width = self.actor.BoundingBox:width() + overage
        end

        self.actor:callForAllComponents("BoundingBoxEditor_onResizeDrag")
    end
end

function BoundingBoxEditor:moveVerticallyBy(y)
    self.actor:setPos(self.actor:pos() + Vector.new(0,y))
end

function BoundingBoxEditor:moveHorizontallyBy(x)
    self.actor:setPos(self.actor:pos() + Vector.new(x,0))
end

function BoundingBoxEditor:onMousePress(x, y, button, wasRelease, isClickConsumed)
    if button == 1 and not wasRelease and not isClickConsumed then
        if not self.actor.BoundingBox:getRect():isVectorWithin(x, y) then
            for i, rect in ipairs(self.cornerGrabHandleRects) do
                if rect:isVectorWithin(x, y) then
                    self.selectedIndex = i + 4
                    self.actor:callForAllComponents("BoundingBoxEditor_onResizeStart")
                    self.actor:scene():consumeClick()
                    return
                end
            end
        end

        for i, rect in ipairs(self.sideGrabHandleRects) do
            if rect:isVectorWithin(x, y) then
                self.selectedIndex = i
                self.actor:callForAllComponents("BoundingBoxEditor_onResizeStart")
                self.actor:scene():consumeClick()
            end
        end
    end

    if button == 1 and wasRelease then
        self.actor:callForAllComponents("BoundingBoxEditor_onResizeEnd")
        self.selectedIndex = nil
        if self.actor.BoundingBox:getArea() <= 0 then
            self.actor:destroy()
        end
    end
end

-- Corners
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

-- Corners small
function BoundingBoxEditor:getBottomRightGrabHandleRectSmall()
    local boundingRect = self.actor.BoundingBox:getRect()
    local x = boundingRect:x() - self.grabHandleWidth + boundingRect:width()
    local y = boundingRect:y() - self.grabHandleWidth + boundingRect:height() + self.grabHandleWidth
    return Rect.new(x, y, self.grabHandleWidth * 2, self.grabHandleWidth)
end

function BoundingBoxEditor:getBottomLeftGrabHandleRectSmall()
    local boundingRect = self.actor.BoundingBox:getRect()
    local x = boundingRect:x() - self.grabHandleWidth
    local y = boundingRect:y() - self.grabHandleWidth + boundingRect:height() + self.grabHandleWidth
    return Rect.new(x, y, self.grabHandleWidth * 2, self.grabHandleWidth)
end

-- Sides
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
