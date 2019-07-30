local CountHowManyActorsInScene = {}

registerComponent(CountHowManyActorsInScene,'CountHowManyActorsInScene')

function CountHowManyActorsInScene:awake()
    debugLog(#self.actor:scene():getAllActors(), " actors in this scene")
    debugLog("good morning")
    debugLog("why can no one see this")
end

function CountHowManyActorsInScene:update(dt)
    debugLog(#self.actor:scene():getAllActors(), " actors in this scene")
end

return CountHowManyActorsInScene