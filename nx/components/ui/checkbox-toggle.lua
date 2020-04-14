local CheckboxToggle = {}

registerComponent(CheckboxToggle, "CheckboxToggle", {"BoundingBox", "Hoverable", "Clickable"})

function CheckboxToggle:setup(startingState, label)
    self.toggleState = startingState
    self.hovered = false
    self:updateAnimation()

    local textRenderer =
        self.actor:addComponent(Components.TextRenderer, label or "", 12, nil, "left", 1, {0, 0, 0}, 16 + 8, 0)

    local textWidth = textRenderer:getWidth()
    if textWidth > 0 then
        self.actor.BoundingBox:setWidth(32 + textWidth)
    end
    self.actor.BoundingBox.offset = Vector.new(0, 0)
end

function CheckboxToggle:awake()
    self.actor.BoundingBox:setDimensions(16, 16)
    self.spriteActor = self.actor:scene():addActor()
    self.spriteActor:addComponent(Components.BoundingBox)
    self.spriteActor:addComponent(Components.SpriteRenderer, "checkbox", "checked")
    self.spriteActor:addComponent(Components.Parent, self.actor)
    self.spriteActor:addComponent(Components.AffixPos, self.actor, 8, 8)
end

function CheckboxToggle:start()
    assert(self.toggleState ~= nil, "setup not run")
end

function CheckboxToggle:Clickable_onClickOn(button)
    if button == 1 then
        self.toggleState = not self.toggleState
        self.actor:callForAllComponents("CheckboxToggle_onStateChange", self.toggleState)
    end
    self:updateAnimation()
end

function CheckboxToggle:Hoverable_onHoverEnd()
    self.hovered = false
    self:updateAnimation()
end

function CheckboxToggle:Hoverable_onHoverStart()
    self.hovered = true
    self:updateAnimation()
end

function CheckboxToggle:updateAnimation()
    local animationName = "unchecked"
    if self.toggleState then
        animationName = "checked"
    end

    if self.hovered then
        animationName = animationName .. "-hovered"
    end

    self.spriteActor.SpriteRenderer:setAnimation(animationName)
end

function CheckboxToggle:getState()
    return self.toggleState
end

return CheckboxToggle
