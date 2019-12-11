local DisplayFrameOfSpriteRenderer = {}

registerComponent(DisplayFrameOfSpriteRenderer, "DisplayFrameOfSpriteRenderer", {"TextRenderer", "SpriteRenderer"})

function DisplayFrameOfSpriteRenderer:awake()
end

function DisplayFrameOfSpriteRenderer:draw(x, y)
end

function DisplayFrameOfSpriteRenderer:update(dt)
    self.actor.TextRenderer.color = {0, 0, 0, 1}
    self.actor.TextRenderer.offset = Vector.new(32, 16)
    self.actor.TextRenderer.text = self.actor.AnimationFrameTracker:get()
end

return DisplayFrameOfSpriteRenderer
