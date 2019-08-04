local BoundingBoxEditor = {}

registerComponent(BoundingBoxEditor, "BoundingBoxEditor", {"BoundingBox"})

function BoundingBoxEditor:setup(minWidth, minHeight, grabHandleWidth)
    assert(minWidth)
    assert(minHeight)
    self.minimumSize = Size.new(minWidth, minHeight)
    self.grabHandleWidth = grabHandleWidth or self.grabHandleWidth
end

function BoundingBoxEditor:awake()
    self.sideGrabHandleRects = {}
    self.cornerGrabHandleRects = {}
    self.selectedIndex = nil
    self.grabHandleWidth = 16
    self.resizeStarted = false

    self.minimumSize = Size.new(64, 64)
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
        self:getBottomLeftGrabHandleRect(),
        self:getBottomRightGrabHandleRect()
    }
end

function BoundingBoxEditor:onMouseMove(x, y, dx, dy)
    x = x + self.actor:scene().camera.x
    y = y + self.actor:scene().camera.y

    if self.selectedIndex then
        local something = (Vector.new(x, y) - self.startPoint):xy()
        local bottomRight = self.selectedIndex == 8
        local topLeft = self.selectedIndex == 5
        local topRight = self.selectedIndex == 6
        local bottomLeft = self.selectedIndex == 7

        local alongTop = self.selectedIndex == 1 or topRight or topLeft
        local alongBottom = self.selectedIndex == 2 or bottomRight or bottomLeft
        local alongLeft = self.selectedIndex == 3 or bottomLeft or topLeft
        local alongRight = self.selectedIndex == 4 or bottomRight or topRight

        if alongTop then
            self:moveTopSide(dy, x, y)
        end

        if alongBottom then
            self:moveBottomSide(dy, x, y)
        end

        if alongLeft then
            self:moveLeftSide(dx, x, y)
        end

        if alongRight then
            self:moveRightSide(dx, x, y)
        end

        self.actor:callForAllComponents("BoundingBoxEditor_onResizeDrag", self.actor.BoundingBox:getRect())
    end
end

function BoundingBoxEditor:onMousePress(x, y, button, wasRelease, isClickConsumed)
    self.selectedIndex = nil
    if button == 1 and not wasRelease and not isClickConsumed then
        if not self.actor.BoundingBox:getRect():isVectorWithin(x, y) then
            for i, rect in ipairs(self.cornerGrabHandleRects) do
                if rect:isVectorWithin(x, y) then
                    self.selectedIndex = i + 4
                    self:startResize(x, y)
                    return
                end
            end
        end

        for i, rect in ipairs(self.sideGrabHandleRects) do
            if rect:isVectorWithin(x, y) then
                self.selectedIndex = i
                self:startResize(x, y)
            end
        end
    end

    if button == 1 and wasRelease and self.resizeStarted then
        self.resizeStarted = false
        self.actor:callForAllComponents("BoundingBoxEditor_onResizeEnd", self.actor.BoundingBox:getRect())
        if self.actor.BoundingBox:getArea() <= 0 then
            self.actor:destroy()
        end
    end
end

function BoundingBoxEditor:startResize(x, y)
    self.actor:callForAllComponents("BoundingBoxEditor_onResizeStart")
    x = x + self.actor:scene().camera.x
    y = y + self.actor:scene().camera.y
    self.startPoint = Vector.new(x, y)
    self.actor:scene():consumeClick()
    self.resizeStarted = true
end

-- Mutators
function BoundingBoxEditor:moveVerticallyBy(y)
    self.actor:setPos(self.actor:pos() + Vector.new(0, y))
end

function BoundingBoxEditor:moveHorizontallyBy(x)
    self.actor:setPos(self.actor:pos() + Vector.new(x, 0))
end

function BoundingBoxEditor:growHorizontallyBy(x)
    self.actor.BoundingBox:setWidth(self.actor.BoundingBox:width() + x)
end

function BoundingBoxEditor:growVerticallyBy(y)
    self.actor.BoundingBox:setHeight(self.actor.BoundingBox:height() + y)
end

function BoundingBoxEditor:getHorizontalOverage()
    return math.max(self.minimumSize.width - self.actor.BoundingBox:width(), 0)
end

function BoundingBoxEditor:getVerticalOverage()
    return math.max(self.minimumSize.height - self.actor.BoundingBox:height(), 0)
end

function BoundingBoxEditor:moveLeftSide(dx, x, y)
    if x < self.actor:pos().x or dx > 0 then
        self:moveHorizontallyBy(dx)
        self:growHorizontallyBy(-dx)
        local overage = self:getHorizontalOverage()
        self:growHorizontallyBy(overage)
        self:moveHorizontallyBy(-overage)
    end
end

function BoundingBoxEditor:moveTopSide(dy, x, y)
    if y < self.actor:pos().y or dy > 0 then
        self:moveVerticallyBy(dy)
        self:growVerticallyBy(-dy)
        local overage = self:getVerticalOverage()
        self:growVerticallyBy(overage)
        self:moveVerticallyBy(-overage)
    end
end

function BoundingBoxEditor:moveBottomSide(dy, x, y)
    if y > self.actor:pos().y + self.actor.BoundingBox:height() or dy < 0 then
        self:growVerticallyBy(dy)
        local overage = self:getVerticalOverage()
        self:growVerticallyBy(overage)
    end
end

function BoundingBoxEditor:moveRightSide(dx, x, y)
    if x > self.actor:pos().x + self.actor.BoundingBox:width() or dx < 0 then
        self:growHorizontallyBy(dx)
        local overage = self:getHorizontalOverage()
        self:growHorizontallyBy(overage)
    end
end

-- Corners
function BoundingBoxEditor:getCornerRect(dx, dy)
    local boundingRect = self.actor.BoundingBox:getRect()
    local x = boundingRect:x() + dx - self.grabHandleWidth
    local y = boundingRect:y() + dy - self.grabHandleWidth
    return Rect.new(x, y, self.grabHandleWidth * 2, self.grabHandleWidth * 2)
end

function BoundingBoxEditor:getTopLeftGrabHandleRect()
    return self:getCornerRect(0, 0)
end

function BoundingBoxEditor:getTopRightGrabHandleRect()
    return self:getCornerRect(self.actor.BoundingBox:getRect():width(), 0)
end

function BoundingBoxEditor:getBottomRightGrabHandleRect()
    return self:getCornerRect(self.actor.BoundingBox:getRect():width(), self.actor.BoundingBox:getRect():height())
end

function BoundingBoxEditor:getBottomLeftGrabHandleRect()
    return self:getCornerRect(0, self.actor.BoundingBox:getRect():height())
end

-- Sides
function BoundingBoxEditor:getLeftGrabHandleRect()
    local rect = self.actor.BoundingBox:getRect()
    rect:setWidth(self.grabHandleWidth)
    rect:move(-rect:width(), 0)
    return rect
end

function BoundingBoxEditor:getRightGrabHandleRect()
    local rect = self.actor.BoundingBox:getRect()
    rect:move(rect:width(), 0)
    rect:setWidth(self.grabHandleWidth)
    return rect
end

function BoundingBoxEditor:getBottomGrabHandleRect()
    local rect = self.actor.BoundingBox:getRect()
    rect:move(0, rect:height())
    rect:setHeight(self.grabHandleWidth)
    return rect
end

function BoundingBoxEditor:getTopGrabHandleRect()
    local rect = self.actor.BoundingBox:getRect()
    rect:setHeight(self.grabHandleWidth)
    rect:move(0, -rect:height())
    return rect
end

return BoundingBoxEditor
