local EdgeOfScene = {}

registerComponent(EdgeOfScene, "EdgeOfScene")

function EdgeOfScene:setup(deflateWidth, deflateHeight)
    self.deflateSize = Size.new(deflateWidth, deflateHeight)
end

function EdgeOfScene:awake()
    self.deflateSize = Size.new()
end

function EdgeOfScene:update(dt)
    if (self.firstFrame or 0) < 2 then
        self.firstFrame = (self.firstFrame or 0) + 1
        return
    end

    local rect = Rect.new(self.actor:scene():getBounds())
    local w, h = self.deflateSize:wh()
    local left, top, right, bottom = rect:inflate(-w, -h):xywh()
    local x, y = self.actor:pos():xy()

    left = left * 2
    top = top * 2

    -- fenestra hack
    if self.actor:scene():getFirstBehavior(Components.Lens) then
        return
    end
    -- /fenestra hack

    if y > bottom then
        self.actor:callForAllComponents("EdgeOfScene_onHitSide", Vector.new(0, -1), Vector.new(x, bottom))
    end

    if y < top then
        self.actor:callForAllComponents("EdgeOfScene_onHitSide", Vector.new(0, 1), Vector.new(x, top))
    end

    if x < left then
        self.actor:callForAllComponents("EdgeOfScene_onHitSide", Vector.new(1, 0), Vector.new(left, y))
    end

    if x > right then
        self.actor:callForAllComponents("EdgeOfScene_onHitSide", Vector.new(-1, 0), Vector.new(right, y))
    end
end

return EdgeOfScene
