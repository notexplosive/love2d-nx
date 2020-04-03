local PlayHeadRenderer = {}

registerComponent(PlayHeadRenderer, "PlayHeadRenderer", {"BoundingBox", "PlayHead"})

function PlayHeadRenderer:draw(x, y)
    local filledRect = self.actor.BoundingBox:getRect()
    local totalWidth = filledRect:width()
    local playHeadTime = self.actor.PlayHead:getPercent()
    filledRect:setWidth(playHeadTime * totalWidth)
    love.graphics.setColor(1, 1, 0)
    love.graphics.rectangle("fill", filledRect:xywh())

    local outlineRect = self.actor.BoundingBox:getRect()
    love.graphics.setColor(1, 1, 0)
    love.graphics.rectangle("line", outlineRect:xywh())
end

function PlayHeadRenderer:update(dt)
end

return PlayHeadRenderer
