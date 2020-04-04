local BoundingBox = {}

registerComponent(BoundingBox, "BoundingBox")

function BoundingBox:setup(w, h, ox, oy)
    self.size = Size.new(w or 64, h or 64)
    self.offset = Vector.new(ox or 0, oy or 0)
end

function BoundingBox:reverseSetup()
    return self:width(), self:height(), self.offset.x, self.offset.y
end

function BoundingBox:getArea()
    return self.size:area()
end

function BoundingBox:width()
    return self.size.width
end

function BoundingBox:height()
    return self.size.height
end

function BoundingBox:setWidth(width)
    self.size.width = width
end

function BoundingBox:setHeight(height)
    self.size.height = height
end

function BoundingBox:getRect()
    return Rect.new(
        self.actor:pos().x - self.offset.x,
        self.actor:pos().y - self.offset.y,
        self.size.width,
        self.size.height
    )
end

function BoundingBox:setDimensions(w, h)
    self.size = Size.new(w, h)
end

function BoundingBox:getDimensions()
    return self.size:wh()
end

function BoundingBox:getSize()
    return Size.new(self.size:wh())
end

function BoundingBox:area()
    return self.size:area()
end

function BoundingBox:isWithinBoundingBox(x, y)
    return self:getRect():isVectorWithin(Vector.new(x, y))
end

function BoundingBox:getCollide(v, y)
    assert(v, "getCollide must be passed something")
    local point = Vector.new(v, y)
    return self:getRect():isVectorWithin(Vector.new(v, y))
end

function BoundingBox:getSideCollidedOn(pos, velocity)
    local left, top, bw, bh = self.actor.BoundingBox:getRect():xywh()
    local right = left + bw
    local bottom = top + bh

    local names = {"top", "bottom", "left", "right"}
    local list = {
        math.abs(pos.y - top),
        math.abs(pos.y - bottom),
        math.abs(pos.x - left),
        math.abs(pos.x - right)
    }

    -- Horizontal case
    if math.abs(velocity.x) < 1 then
        if velocity.y > 0 then
            side = "bottom"
        else
            side = "top"
        end
    elseif math.abs(velocity.y) < 1 then
        if velocity.x > 0 then
            side = "left"
        else
            side = "right"
        end
    end

    local side = names[getIndexOfMinimum(list)]

    return side
end

function BoundingBox:EditorNode_createEditorComponent(editorNode)
    editorNode:addEditorComponent(Components.BoundingBoxEditor)
    editorNode.allowAngleTransform = false
end

return BoundingBox
