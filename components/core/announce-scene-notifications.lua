local AnnounceSceneNotifications = {}

registerComponent(AnnounceSceneNotifications,'AnnounceSceneNotifications')

function AnnounceSceneNotifications:onNotify(msg)
    debugLog("NOTIFICATION: ",msg)
end

return AnnounceSceneNotifications