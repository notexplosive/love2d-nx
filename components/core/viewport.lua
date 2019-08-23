local Viewport = {}

registerComponent(Viewport, "Viewport")

function Viewport:awake()
    self.startPos = self.actor:pos()
    self.cooldown = 0
end

-- Viewport DOES NOT and SHOULD NOT HAVE A :draw()

function Viewport:update(dt)
    self:correctHeight()

    if self.cooldown > 0 then
        self.cooldown = self.cooldown - dt
    end

    local averagePos = self.startPos:clone()
    local centerPos = self.actor:scene():getFirstActorWithBehavior(Components.Weapon):pos()
    local scene = self.actor:scene()
    -- TODO: for i, actor in scene:eachActorWith(Components.NewProjectile) do
    for i, actor in ipairs(scene:getAllActorsWithBehavior(Components.NewProjectile)) do
        if not actor.NewProjectile.isSimulated and not actor.NewProjectile.isInactive then
            local displacement = actor:pos() - centerPos
            averagePos = averagePos + displacement / 2

            if displacement:length() > self.actor.BoundingBox:width() * 2 then
                self.cooldown = 1
                actor:destroy()
            end

            self.cooldown = 0
        end
    end

    if self.cooldown <= 0 then
        self.actor:setPos(self.actor:pos() + (averagePos - self.actor:pos()) / 2)
    end
end

function Viewport:Draggable_onDrag()
    self:awake()
    self.cooldown = 1
end

function Viewport:correctHeight()
    self.actor.BoundingBox.height = 1 / self:getScale() * love.graphics.getHeight()
end

function Viewport:getScale()
    local x, y, w, h = self.actor.BoundingBox:getRect():xywh()
    return love.graphics.getWidth() / w
end

--
-- api
--

function Viewport:sceneDraw()
    love.graphics.push()
    local scale = self:getScale()
    love.graphics.scale(scale, scale)
    love.graphics.translate((-self.actor:pos()):xy())
    self.actor:scene():draw(true)
    love.graphics.pop()
end

function Viewport:wait(time)
    self.cooldown = time
end

return Viewport
