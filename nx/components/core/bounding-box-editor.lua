local BoundingBoxEditor = {}

registerComponent(BoundingBoxEditor, "BoundingBoxEditor", {"BoundingBox"})

function BoundingBoxEditor:setup(minWidth, minHeight, grabHandleWidth)
    assert(minWidth, "missing setup parmeter minWidth")
    assert(minHeight, "missing setup parmeter minHeight")
    self.minimumSize = Size.new(minWidth, minHeight)
    self.grabHandleWidth = grabHandleWidth or self.grabHandleWidth
end

function BoundingBoxEditor:reverseSetup()
    local w, h = self.minimumSize.width, self.minimumSize.height
    return w, h, self.grabHandleWidth
end

function BoundingBoxEditor:awake()
    self.sideGrabHandleRects = {}
    self.cornerGrabHandleRects = {}
    self.selectedIndex = nil
    self.grabHandleWidth = 8
    self.resizeStarted = false
    self.hoverIndex = nil

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

function BoundingBoxEditor:onMouseMove(x, y, dx, dy, isHoverConsumed)
    self.hoverIndex = nil
    if not self.actor.visible then
        return
    end

    if not self.selectedIndex then
        if not isHoverConsumed then
            for i, rect in ipairs(self.sideGrabHandleRects) do
                if rect:isVectorWithin(x, y) then
                    self.hoverIndex = i
                end
            end

            if not self:getResizeRect():isVectorWithin(x, y) then
                for i, rect in ipairs(self.cornerGrabHandleRects) do
                    if rect:isVectorWithin(x, y) then
                        self.hoverIndex = i + 4
                    end
                end
            end

            if self.hoverIndex then
                self.actor:scene():consumeHover()
            end
        end
    else
        self.hoverIndex = self.selectedIndex
    end

    if self.selectedIndex then
        local currentMousePos = Vector.new(x, y)
        local mouseDeltaFromStart = currentMousePos - self.startPoint

        self.actor:scene():consumeHover()
        local bottomRight = self.selectedIndex == 8
        local topLeft = self.selectedIndex == 5
        local topRight = self.selectedIndex == 6
        local bottomLeft = self.selectedIndex == 7

        local alongTop = self.selectedIndex == 1 or topRight or topLeft
        local alongBottom = self.selectedIndex == 2 or bottomRight or bottomLeft
        local alongLeft = self.selectedIndex == 3 or bottomLeft or topLeft
        local alongRight = self.selectedIndex == 4 or bottomRight or topRight

        if alongTop then
            self:moveTopSide(mouseDeltaFromStart.y, x, y)
        end

        if alongBottom then
            self:moveBottomSide(mouseDeltaFromStart.y, x, y)
        end

        if alongLeft then
            self:moveLeftSide(mouseDeltaFromStart.x, x, y)
        end

        if alongRight then
            self:moveRightSide(mouseDeltaFromStart.x, x, y)
        end

        self.actor:callForAllComponents("BoundingBoxEditor_onResizeDrag", self:getResizeRect())
    end
end

function BoundingBoxEditor:onMousePress(x, y, button, wasRelease, isClickConsumed)
    local startedNotSelecting = self.selectedIndex == nil

    if not self.actor.visible then
        return
    end

    if isClickConsumed then
        self.selectedIndex = nil
        self.hoverIndex = nil
        self:endResizeIfApplicable()
        return
    end

    self.savedRect = nil
    self.selectedIndex = nil
    if button == 1 and not wasRelease and not isClickConsumed then
        if not self:getResizeRect():isVectorWithin(x, y) then
            for i, rect in ipairs(self.cornerGrabHandleRects) do
                if rect:isVectorWithin(x, y) then
                    self:startResize(i + 4, x, y)
                    return
                end
            end
        end

        for i, rect in ipairs(self.sideGrabHandleRects) do
            if rect:isVectorWithin(x, y) then
                self:startResize(i, x, y)
            end
        end
    end

    if button == 1 and wasRelease and self.resizeStarted then
        self:endResizeIfApplicable()
        if self.actor.BoundingBox:getArea() <= 0 then
            self.actor:destroy()
        end
    end
end

function BoundingBoxEditor:endResizeIfApplicable()
    if self.resizeStarted then
        self.resizeStarted = false
        self.actor:callForAllComponents("BoundingBoxEditor_onResizeEnd", self:getResizeRect())
    end
end

function BoundingBoxEditor:startResize(selectedIndex, x, y)
    self.savedRect = self.actor.BoundingBox:getRect()
    self.selectedIndex = selectedIndex
    self.startPoint = Vector.new(x, y)
    self.actor:callForAllComponents("BoundingBoxEditor_onResizeStart")
    self.actor:scene():consumeClick()
    self.resizeStarted = true
end

function BoundingBoxEditor:isDragging()
    return self.selectedIndex ~= nil
end

-- Mutators
function BoundingBoxEditor:moveVerticallyBy(y)
    self.actor:setPosY(self.savedRect.pos.y + y)
end

function BoundingBoxEditor:moveHorizontallyBy(x)
    self.actor:setPosX(self.savedRect.pos.x + x)
end

function BoundingBoxEditor:growHorizontallyBy(x)
    self.actor.BoundingBox:setWidth(self.savedRect:width() + x)

    if self.actor.BoundingBox:width() < self.minimumSize.width then
        local overage = self.actor.BoundingBox:width() - self.minimumSize.width
        self.actor.BoundingBox:setWidth(self.minimumSize.width)
        return overage
    end

    return 0
end

function BoundingBoxEditor:growVerticallyBy(y)
    self.actor.BoundingBox:setHeight(self.savedRect:height() + y)

    if self.actor.BoundingBox:height() < self.minimumSize.height then
        local overage = self.actor.BoundingBox:height() - self.minimumSize.height
        self.actor.BoundingBox:setHeight(self.minimumSize.height)
        return overage
    end

    return 0
end

function BoundingBoxEditor:moveLeftSide(dx, x, y)
    local overage = self:growHorizontallyBy(-dx)
    self:moveHorizontallyBy(dx + overage)
end

function BoundingBoxEditor:moveTopSide(dy, x, y)
    local overage = self:growVerticallyBy(-dy)
    self:moveVerticallyBy(dy + overage)
end

function BoundingBoxEditor:moveBottomSide(dy, x, y)
    self:growVerticallyBy(dy)
end

function BoundingBoxEditor:moveRightSide(dx, x, y)
    self:growHorizontallyBy(dx)
end

-- Corners
function BoundingBoxEditor:getCornerRect(dx, dy)
    local boundingRect = self:getResizeRect()
    local x = boundingRect:x() + dx - self.grabHandleWidth
    local y = boundingRect:y() + dy - self.grabHandleWidth
    return Rect.new(x, y, self.grabHandleWidth * 2, self.grabHandleWidth * 2)
end

function BoundingBoxEditor:getTopLeftGrabHandleRect()
    return self:getCornerRect(0, 0):move(0, 0)
end

function BoundingBoxEditor:getTopRightGrabHandleRect()
    return self:getCornerRect(self:getResizeRect():width(), 0):move(0, 0)
end

function BoundingBoxEditor:getBottomRightGrabHandleRect()
    return self:getCornerRect(self:getResizeRect():width(), self:getResizeRect():height())
end

function BoundingBoxEditor:getBottomLeftGrabHandleRect()
    return self:getCornerRect(0, self:getResizeRect():height())
end

-- Sides
function BoundingBoxEditor:getLeftGrabHandleRect()
    local rect = self:getResizeRect()
    rect:setWidth(self.grabHandleWidth)
    rect:move(-self.grabHandleWidth, 0)
    return rect
end

function BoundingBoxEditor:getRightGrabHandleRect()
    local rect = self:getResizeRect()
    rect:move(rect:width(), 0)
    rect:setWidth(self.grabHandleWidth)
    return rect
end

function BoundingBoxEditor:getBottomGrabHandleRect()
    local rect = self:getResizeRect()
    rect:move(0, rect:height())
    rect:setHeight(self.grabHandleWidth)
    return rect
end

function BoundingBoxEditor:getTopGrabHandleRect()
    local rect = self:getResizeRect()
    rect:setHeight(self.grabHandleWidth)
    rect:move(0, -self.grabHandleWidth)
    return rect
end

function BoundingBoxEditor:getTopGrabHandleRect_Alt()
    local rect = self:getResizeRect()
    rect:setHeight(self.grabHandleWidth)
    rect:move(0, -self.grabHandleWidth * 2)
    return rect
end

function BoundingBoxEditor:getResizeRect()
    local rect = self.actor.BoundingBox:getRect()
    -- fenestra hack
    rect:inflate(-64, -64)
    rect:move(0, -20)
    rect:setHeight(rect:height() + 20)
    -- /fenestra hack
    return rect
end

return BoundingBoxEditor
