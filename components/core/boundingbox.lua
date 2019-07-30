local BoundingBox = {}

registerComponent(BoundingBox, "BoundingBox")

function BoundingBox:setup(w, h, ox, oy)
    self.forceCustom = true
    self.size = Size.new(w,h)
    self.offset = Vector.new(ox, oy)
end

function BoundingBox:reverseSetup()
    return self.width,self.height,self.offset.x,self.offset.y
end

function BoundingBox:awake()
    self.size = Size.new(64,64)
    self.offset = Vector.new(0, 0)
    self.forceCustom = false
    self.visible = false
end

function BoundingBox:draw(x, y)
    if self.visible then
        love.graphics.rectangle("line", self:getRect():xywh())
    end
end

function BoundingBox:getArea()
    return self.size:area()
end

function BoundingBox:getRect()
    local camera = self.actor:scene().camera
    if self.actor.SpriteRenderer and (self.offset.x == 0 or self.offset.y == 0) and not self.forceCustom then
        return self.actor.SpriteRenderer:getBoundingBox()
    end

    return Rect.new(self.actor:pos().x - self.offset.x - camera.x, self.actor:pos().y - self.offset.y - camera.y, self.size.width, self.size.height)
end

function BoundingBox:setDimensions(w, h)
    self.size = Size.new(w,h)
    self.forceCustom = true
end

function BoundingBox:getDimensions()
    return self.size:wh()
end

function BoundingBox:isWithinBoundingBox(x, y)
    return self:getRect():isVectorWithin(Vector.new(x,y))
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
