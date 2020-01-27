local Viewport = {}

registerComponent(Viewport, "Viewport")

local font = love.graphics.newFont(22)

function Viewport:setup(scale)
    self.scale = scale
end

function Viewport:awake()
    self.actor:addComponent(Components.BoundingBox)
    self.scale = 1

    self.actor:scene():setViewport(self)
end

function Viewport:draw(x, y)
    if DEBUG then
        love.graphics.setColor(1, 1, 0, 1, 1)
        love.graphics.rectangle("line", self.actor.BoundingBox:getRect():inflate(-5, -5):xywh())
    end
end

function Viewport:onKeyPress(button, scancode, wasRelease)
    if DEBUG and button == "q" and not wasRelease then
        if self.actor:scene():getViewport() == self then
            self.actor:scene():setViewport(nil)
        else
            self.actor:scene():setViewport(self)
        end
    end
end

function Viewport:update(dt)
    self.actor.BoundingBox:setWidth(love.graphics.getWidth() / self.scale)
    self.actor.BoundingBox:setHeight(love.graphics.getHeight() / self.scale)
end

--
-- api
--

function Viewport:getScale()
    return self.scale
end

function Viewport:setScale(scale)
    self.scale = scale
end

function Viewport:sceneDraw()
    love.graphics.push()
    local scale = self:getScale()
    love.graphics.scale(scale, scale)
    love.graphics.translate((-self.actor:pos()):xy())
    self.actor:scene():draw_impl()
    love.graphics.pop()

    if DEBUG then
        love.graphics.setColor(1, 1, 0, 1, 1)
        love.graphics.setFont(font)
        love.graphics.print("viewport scale: " .. self.scale .. "\npress q to disconnect viewport", 7, 5)
    end
end

return Viewport
