local BoundingBox = {}

registerComponent(BoundingBox, "BoundingBox")

function BoundingBox:setup(w, h, ox, oy)
    self.forceCustom = true
    self.width = w
    self.height = h
    self.offset = Vector.new(ox, oy)
end

function BoundingBox:reverseSetup()
    return self.width,self.height,self.offset.x,self.offset.y
end

function BoundingBox:awake()
    self.width = 64
    self.height = 64
    self.offset = Vector.new(0, 0)
    self.forceCustom = false
    self.visible = false
end

function BoundingBox:draw(x, y)
    if self.visible then
        love.graphics.rectangle("line", self:getRect())
    end
end

function BoundingBox:getArea()
    return self.width * self.height
end

function BoundingBox:getRect()
    local camera = self.actor:scene().camera
    if self.actor.SpriteRenderer and (self.offset.x == 0 or self.offset.y == 0) and not self.forceCustom then
        return self.actor.SpriteRenderer:getBoundingBox()
    end

    return self.actor:pos().x - self.offset.x - camera.x, self.actor:pos().y - self.offset.y - camera.y, self.width, self.height
end

function BoundingBox:setDimensions(w, h)
    self.width = w
    self.height = h
    self.forceCustom = true
end

function BoundingBox:getDimensions()
    return self.width, self.height
end

function BoundingBox:isWithinBoundingBox(x, y)
    return isWithinRect(x, y, self:getRect())
end

function BoundingBox:isOutOfBounds()
    if self.actor.scene then
        local x, y, w, h = self:getRect()
        local x2, y2 = x + w, y + h
        return not isWithinRect(x, y, self.actor:scene():getBounds()) and
            not isWithinRect(x, y2, self.actor:scene():getBounds()) and
            not isWithinRect(x2, y, self.actor:scene():getBounds()) and
            not isWithinRect(x2, y2, self.actor:scene():getBounds())
    end

    print(self.actor.name .. " bounds check not applicable, no scene")
end

function BoundingBox:getSideCollidedOn(pos, velocity)
    local left, top, bw, bh = self.actor.BoundingBox:getRect()
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
