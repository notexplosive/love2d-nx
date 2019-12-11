local PlayAnimationOnClick = {}

registerComponent(PlayAnimationOnClick, "PlayAnimationOnClick", {"Clickable", "SpriteRenderer"})

function PlayAnimationOnClick:setup(animName)
    self.animName = animName
end

function PlayAnimationOnClick:Clickable_onClickOn(button)
    if button == 1 and not self.oldAnim then
        self.oldAnim = self.actor.SpriteRenderer:getAnimation()
        self.actor.SpriteRenderer:setAnimation(self.animName)
        self.actor.SpriteRenderer:setLoop(false)
        debugLog(self.oldAnim)
    end
end

function PlayAnimationOnClick:update(dt)
    if not self.actor.SpriteRenderer:isPlaying() and self.oldAnim then
        self.actor.SpriteRenderer:setAnimation(self.oldAnim)
        self.oldAnim = nil
    end
end

return PlayAnimationOnClick
