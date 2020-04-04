local SceneCanBeFrameFrozen = {}

registerComponent(SceneCanBeFrameFrozen, "SceneCanBeFrameFrozen")

function SceneCanBeFrameFrozen:setup(boolean)
    if boolean == false then
        self:destroy()
    end
end

function SceneCanBeFrameFrozen:freeze()
    self.actor:scene().freeze = true
    debugLog("freezin")
end

function SceneCanBeFrameFrozen:unfreeze()
    self.actor:scene().freeze = false
    debugLog("unfreezin")
end

function SceneCanBeFrameFrozen:onScroll(x, y)
    if self.actor:scene().freeze and y < 0 then
        self.actor:scene().freeze = false
        self.actor:scene():update(1 / 60)
        self.actor:scene().freeze = true
    end
end

return SceneCanBeFrameFrozen
