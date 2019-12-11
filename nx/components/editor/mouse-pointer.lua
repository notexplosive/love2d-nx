local MousePointer = {}

registerComponent(MousePointer, "MousePointer")

function MousePointer:awake()
    love.mouse.setVisible(false)
    self.actor.SpriteRenderer:setAnimation("up-down")
    self.leftButtonDown = false

    self.actor:addComponent(Components.AlwaysOnTop)
end

function MousePointer:update(dt)
    if not self.leftButtonDown then
        local hoverIndex = nil
        for i, actor in gameScene:eachActorWith(Components.BoundingBoxEditor) do
            if actor.BoundingBoxEditor.hoverIndex then
                hoverIndex = actor.BoundingBoxEditor.hoverIndex
                break
            end
        end

        self.actor.SpriteRenderer:setAnimation("pointer")

        if hoverIndex == 1 or hoverIndex == 2 then
            self.actor.SpriteRenderer:setAnimation("up-down")
        end
        if hoverIndex == 3 or hoverIndex == 4 then
            self.actor.SpriteRenderer:setAnimation("left-right")
        end
        if hoverIndex == 5 or hoverIndex == 8 then
            self.actor.SpriteRenderer:setAnimation("top-left")
        end
        if hoverIndex == 6 or hoverIndex == 7 then
            self.actor.SpriteRenderer:setAnimation("top-right")
        end
    end

    if self.leftButtonDown then
        for i, actor in gameScene:eachActorWith(Components.MoveOnDrag) do
            if actor.Draggable.dragging then
                self.actor.SpriteRenderer:setAnimation("translate")
                break
            end
        end
    end
end

function MousePointer:onMousePress(x, y, button, wasRelease)
    if button == 1 then
        self.leftButtonDown = not wasRelease
    end

    if button == 1 and wasRelease then
        self.actor.SpriteRenderer:setAnimation("pointer")
    end
end

function MousePointer:onDestroy()
    love.mouse.setVisible(true)
end

return MousePointer
