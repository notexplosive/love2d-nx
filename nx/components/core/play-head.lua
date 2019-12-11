local PlayHead = {}

registerComponent(PlayHead, "PlayHead")

function PlayHead:setup(maxTime)
    self.maxTime = maxTime
end

function PlayHead:awake()
    self.time = 0
    self.maxTime = 0
    self.isPlaying = true
    self.isLooping = true
end

function PlayHead:update(dt)
    if self.isPlaying then
        self:set(self.time + dt)
    end
end

--
-- Public API
--

function PlayHead:get()
    return self.time
end

function PlayHead:set(time)
    if self.isLooping then
        if time > self.maxTime then
            self.actor:callForAllComponents("PlayHead_onLoop")
        end

        if self.maxTime ~= 0 then
            self.time = time % self.maxTime
        end
    else
        if time > self.maxTime then
            self:stop()
        else
            self.time = time
        end
    end
end

function PlayHead:setLoop(b)
    self.isLooping = b
end

function PlayHead:playing()
    return self.isPlaying
end

function PlayHead:play()
    self.isPlaying = true
end

function PlayHead:pause()
    self.isPlaying = false
end

function PlayHead:stop()
    self.isPlaying = false
    self.time = 0
end

function PlayHead:PlayHead_onLoop()
    self._hasLoopedFlagForTesting = true
end

local Test = require("nx/test")
Test.registerComponentTest(
    PlayHead,
    function()
        local Actor = require("nx/game/actor")
        local actor = Actor.new("testActor")

        local subject = actor:addComponent(PlayHead, 5)
        Test.assert(0, subject:get(), "Playhead starts at time 0")

        subject:update(1)
        Test.assert(1, subject:get(), "One second has passed")

        Test.assert(nil, subject._hasLoopedFlagForTesting, "Has not looped")

        subject:update(6)
        Test.assert(2, subject:get(), "Time wraps around maxTime")
        Test.assert(true, subject._hasLoopedFlagForTesting, "Has looped")

        subject:update(1)
        Test.assert(3, subject:get(), "Has looped to the right location")

        subject:set(3)
        Test.assert(3, subject:get(), "Set time")

        Test.assert(true, subject:playing(), "Is playing")
        subject:pause()
        Test.assert(false, subject:playing(), "Is paused")

        local timeBeforeUpdate = subject:get()
        subject:update(10.25)
        Test.assert(timeBeforeUpdate, subject:get(), "Update does not advance playhead when paused")

        subject:stop()
        Test.assert(0, subject:get(), "Stop sets time to zero")
    end
)

return PlayHead
