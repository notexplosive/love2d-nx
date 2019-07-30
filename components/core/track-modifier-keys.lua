local TrackModifierKeys = {}

registerComponent(TrackModifierKeys,'TrackModifierKeys')

function TrackModifierKeys:awake()
    self.shift = false
    self.alt = false
    self.ctrl = false
end

function TrackModifierKeys:onKeyPress(key,scancode,wasRelease)
    if string.find(scancode,'shift') then
        self.shift = not wasRelease
    end

    if string.find(scancode,'ctrl') then
        self.ctrl = not wasRelease
    end

    if string.find(scancode,'alt') then
        self.alt = not wasRelease
    end
end

return TrackModifierKeys