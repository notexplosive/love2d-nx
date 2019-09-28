local TreeNode = {}

registerComponent(TreeNode, "TreeNode")

function TreeNode:setup(data)
    self.data = data
end

function TreeNode:draw(x, y)
    if self:hasBoundingBox() then
        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.rectangle("fill", self.actor.BoundingBox:getRect():xywh())
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.rectangle("fill", self.actor.BoundingBox:getRect():inflate(-2, -2):xywh())
    end
end

function TreeNode:update(dt)
    if self:isRoot() then
        self:organize()
    end
end

function TreeNode:organize()
    local height = self:height()
    local pos = self.actor:pos()
    for i, child in ipairs(self:getChildren()) do
        child:setPos(pos.x + self:getIndent(), pos.y + height)
        height = height + child.TreeNode:organize()
    end

    return height
end

function TreeNode:height()
    if not self.actor.BoundingBox then
        return 0
    end
    return self.actor.BoundingBox:height()
end

function TreeNode:getIndent()
    if self:hasBoundingBox() then
        return 5
    end

    return 0
end

function TreeNode:hasBoundingBox()
    return self.actor.BoundingBox ~= nil
end

function TreeNode:isRoot()
    return self.actor.Parent == nil
end

function TreeNode:getChildren()
    if not self.actor.Children then
        return {}
    end
    return self.actor.Children:get()
end

function TreeNode:clear()
    for i, child in ipairs(self:getChildren()) do
        child:destroy()
    end
end

function TreeNode:addNode(data, parent)
    -- TreeNode should not own this
    local child = self.actor:scene():addActor()
    local width = 150
    local textOffsetX = 2
    child:addComponent(Components.Parent, self.actor)
    child:addComponent(Components.BoundingBox, width, 15)
    child:addComponent(Components.TreeNode, parent or self.actor)
    child:addComponent(Components.TextRenderer, data, "12", width - textOffsetX, "left", 1, {0, 0, 0, 1}, textOffsetX)

    self:organize()

    return child.TreeNode
end

return TreeNode
