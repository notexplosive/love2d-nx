local ComponentsRenderer = {}

registerComponent(ComponentsRenderer, "ComponentsRenderer")

function ComponentsRenderer:awake()
end

function ComponentsRenderer:draw(x, y)
    if not self.actor.EditorNode then
        return
    end

    if self.actor.Selectable:selected() then
        local text = ''
        for i, component in ipairs(self.actor.components or {}) do
            text = text .. component.name
            text = text .. "\n"
        end
        love.graphics.print(text, math.floor(x), math.floor(y), 0, 1, 1, love.graphics.getFont():getWidth(text) / 2, 128)
    end
end

function ComponentsRenderer:update(dt)
end

return ComponentsRenderer
