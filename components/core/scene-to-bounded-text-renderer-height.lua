local SceneToBoundedTextRendererHeight = {}

registerComponent(SceneToBoundedTextRendererHeight, "SceneToBoundedTextRendererHeight", {"BoundedTextRenderer"})

function SceneToBoundedTextRendererHeight:awake()
    self:update()
end

function SceneToBoundedTextRendererHeight:update(dt)
    self.actor:scene().height = self.actor.BoundedTextRenderer:getNeededHeight() + 2
end

return SceneToBoundedTextRendererHeight
