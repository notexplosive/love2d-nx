local DestroyMeWhenTheyAreDestroyed = {}

registerComponent(DestroyMeWhenTheyAreDestroyed, "DestroyMeWhenTheyAreDestroyed")

function DestroyMeWhenTheyAreDestroyed:setup(targetActor)
    targetActor:addComponentSafe(Components.DestroyWith, self.actor)
end

return DestroyMeWhenTheyAreDestroyed
