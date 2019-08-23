local PlaySoundOnDestroy = {}

registerComponent(PlaySoundOnDestroy,'PlaySoundOnDestroy')

function PlaySoundOnDestroy:setup(soundName)
    self.sound = Assets.sounds[soundName]
end

function PlaySoundOnDestroy:onDestroy()
    self.sound:stopThenPlay()
end

return PlaySoundOnDestroy