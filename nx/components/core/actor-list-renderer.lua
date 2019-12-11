-- TreeNode is a more generalized version of this

local ActorListRenderer = {}

registerComponent(ActorListRenderer, "ActorListRenderer")

function ActorListRenderer:draw(x, y)
    self.line = 0
    for _, actor in gameScene:eachActor() do
        self:drawTextBox(x, y, actor.name)

        if actor.Selectable and actor.Selectable:selected() then
            for _, component in ipairs(actor.components) do
                self:drawTextBox(x + 20, y, component.name)
            end
        end
    end
end

function ActorListRenderer:drawTextBox(x, y, text)
    local rect = Rect.new(x, y + (self.line) * 34, 256, 32)
    rect:move(1, 1)
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.rectangle("fill", rect:xywh())
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle("fill", rect:inflate(-2, -2):xywh())
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.print(text, rect.pos.x, rect.pos.y)
    self.line = self.line + 1
end

return ActorListRenderer
