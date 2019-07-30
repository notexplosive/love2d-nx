local PlaySound = {}

registerComponent(PlaySound,'PlaySound')

function PlaySound:setup(soundName,loop)
    Assets[soundName]:play()
    Assets[soundName].source:setLooping(loop or false)
end

return PlaySound