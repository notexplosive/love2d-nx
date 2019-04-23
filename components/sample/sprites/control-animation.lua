local ControlAnimation = {}

registerComponent(ControlAnimation, "ControlAnimation", {"SpriteRenderer"})

function ControlAnimation:awake()
    self:setAnim(1)
end

function ControlAnimation:onKeyPress(key, scancode, wasRelease)
    if not wasRelease then
        local index = tonumber(key)
        if index then
            self:setAnim(index)
        end
    end
end

function ControlAnimation:setAnim(index)
    local anim = self.actor.SpriteRenderer.sprite:getAllAnimations()[index]
    if anim then
        self.actor.SpriteRenderer:setAnimation(anim.name)
    end
end

return ControlAnimation
