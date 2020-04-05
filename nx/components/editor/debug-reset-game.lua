local DebugResetGame = {}

registerComponent(DebugResetGame, "DebugResetGame")

function DebugResetGame:setup()
    self.actor:addComponentSafe(Components.TrackModifierKeys)
end

function DebugResetGame:onKeyPress(key, scancode, wasRelease)
    if key == "r" and wasRelease and ALLOW_DEBUG and self.actor.TrackModifierKeys.ctrl then
        runGame()
        debugLog("All scenes restarted")
    end
end

return DebugResetGame
