local SceneCanBeFrameFrozen = {}

registerComponent(SceneCanBeFrameFrozen, "SceneCanBeFrameFrozen")

function SceneCanBeFrameFrozen:setup(boolean)
    if boolean == false then
        self:destroy()
    end
end

function SceneCanBeFrameFrozen:freeze()
    self.actor:scene().freeze = true
end

function SceneCanBeFrameFrozen:unfreeze()
    self.actor:scene().freeze = false
end

function SceneCanBeFrameFrozen:tick(seconds)
    if self.actor:scene().freeze then
        self.actor:scene().freeze = false
        self.actor:scene():update(seconds)
        self.actor:scene().freeze = true
    end
end

return SceneCanBeFrameFrozen
