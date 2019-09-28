local SpriteButtonRenderer = {}

registerComponent(SpriteButtonRenderer, "SpriteButtonRenderer", {"SpriteRenderer", "Hoverable", "Clickable"})

local defaultColor = {1,1,0.5,1}
local hoverColor = {0.75,0.75,0.25,1}

function SpriteButtonRenderer:update()
    local hover = self.actor.Hoverable:getHoverConsume()

    if hover then
        self.actor.SpriteRenderer.color = hoverColor
    else
        self.actor.SpriteRenderer.color = defaultColor
    end
end

return SpriteButtonRenderer
