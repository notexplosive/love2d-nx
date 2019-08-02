local BoundingBoxEditor = {}

registerComponent(BoundingBoxEditor, "BoundingBoxEditor", {"BoundingBox"})

function BoundingBoxEditor:awake()
    self.sideGrabHandleRects = {}
    self.cornerGrabHandleRects = {}
    self.selectedIndex = nil
    self.grabHandleWidth = 10

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
        self:getBottomRightGrabHandleRect(),
        self:getBottomLeftGrabHandleRect()
    }
end

function BoundingBoxEditor:onMouseMove(x, y, dx, dy)
    x = x + self.actor:scene().camera.x
    y = y + self.actor:scene().camera.y

    if self.selectedIndex then
        local alongTop = self.selectedIndex == 1 or self.selectedIndex == 6 or self.selectedIndex == 5
        local alongBottom = self.selectedIndex == 2 or self.selectedIndex == 7 or self.selectedIndex == 8
        local alongLeft = self.selectedIndex == 3 or self.selectedIndex == 5 or self.selectedIndex == 8
        local alongRight = self.selectedIndex == 4 or self.selectedIndex == 6 or self.selectedIndex == 7

        if alongTop and (y < self.actor:pos().y or dy > 0) then
            self:moveVerticallyBy(dy)
            self:growVerticallyBy(-dy)
            local overage = self:getVerticalOverage()
            self:growVerticallyBy(overage)
            self:moveVerticallyBy(-overage)
        end

        if alongBottom and (y > self.actor:pos().y + self.actor.BoundingBox:height() or dy < 0) then
            self:growVerticallyBy(dy)
            local overage = self:getVerticalOverage()
            self:growVerticallyBy(overage)
        end

        if alongLeft and (x < self.actor:pos().x or dx > 0) then
            self:moveHorizontallyBy(dx)
            self:growHorizontallyBy(-dx)
            local overage = self:getHorizontalOverage()
            self:growHorizontallyBy(overage)
            self:moveHorizontallyBy(-overage)
        end

        if alongRight and (x > self.actor:pos().x + self.actor.BoundingBox:width() or dx < 0) then
            self:growHorizontallyBy(dx)
            local overage = self:getHorizontalOverage()
            self:growHorizontallyBy(overage)
        end

        self.actor:callForAllComponents("BoundingBoxEditor_onResizeDrag")
    end
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

-- Corners
function BoundingBoxEditor:getCornerRect(ox,oy)
    local boundingRect = self.actor.BoundingBox:getRect()
    local x = boundingRect:x() - self.grabHandleWidth + ox
    local y = boundingRect:y() - self.grabHandleWidth + oy
    return Rect.new(x, y, self.grabHandleWidth * 2, self.grabHandleWidth * 2)
end

function BoundingBoxEditor:getTopLeftGrabHandleRect()
    return self:getCornerRect(0,0)
end

function BoundingBoxEditor:getTopRightGrabHandleRect()
    local boundingRect = self.actor.BoundingBox:getRect()
    return self:getCornerRect(boundingRect:width(),0)
end

function BoundingBoxEditor:getBottomRightGrabHandleRect()
    local boundingRect = self.actor.BoundingBox:getRect()
    return self:getCornerRect(boundingRect:width(),boundingRect:height())
end

function BoundingBoxEditor:getBottomLeftGrabHandleRect()
    local boundingRect = self.actor.BoundingBox:getRect()
    return self:getCornerRect(0,boundingRect:height())
end

-- Corners small
function BoundingBoxEditor:getBottomRightGrabHandleRectSmall()
    local rect = self:getBottomRightGrabHandleRect()
    rect:setHeight(rect:height()/2)
    rect:move(0,rect:height())
    return rect
end

function BoundingBoxEditor:getBottomLeftGrabHandleRectSmall()
    local rect = self:getBottomLeftGrabHandleRect()
    rect:setHeight(rect:height()/2)
    rect:move(0,rect:height())
    return rect
end

-- Sides
function BoundingBoxEditor:getLeftGrabHandleRect()
    local rect = self.actor.BoundingBox:getRect()
    rect:setWidth(self.grabHandleWidth)
    rect:move(-rect:width(),0)
    return rect
end

function BoundingBoxEditor:getRightGrabHandleRect()
    local rect = self.actor.BoundingBox:getRect()
    rect:move(rect:width(),0)
    rect:setWidth(self.grabHandleWidth)
    return rect
end

function BoundingBoxEditor:getBottomGrabHandleRect()
    local rect = self.actor.BoundingBox:getRect()
    rect:move(0,rect:height())
    rect:setHeight(self.grabHandleWidth)
    return rect
end

function BoundingBoxEditor:getTopGrabHandleRect()
    local rect = self.actor.BoundingBox:getRect()
    rect:setHeight(self.grabHandleWidth)
    rect:move(0,-rect:height())
    return rect
end

return BoundingBoxEditor
