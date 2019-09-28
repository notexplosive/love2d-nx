local PlaceActorWith = {}

registerComponent(PlaceActorWith, "PlaceActorWith")

function PlaceActorWith:setup(componentClass, ...)
    self.componentClass = componentClass
    self.args = {...}
end

function PlaceActorWith:awake()
    self.actor:addComponentSafe(Components.Uneditable)
end

function PlaceActorWith:draw(x, y)
    local mx, my = love.mouse.getPosition()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.circle("line", mx, my, 32)
end

function PlaceActorWith:onMousePress(x, y, button, wasRelease)
    if button == 1 and not wasRelease then
        local actor = self.actor:scene():addActor()
        actor:addComponent(self.componentClass, unpack(self.args))
        actor:setPos(x, y)
        actor:addComponent(Components.SelectWhenAble)
        self.actor:destroy()
    end
end

return PlaceActorWith
