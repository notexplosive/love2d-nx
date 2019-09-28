local AnimationFrameTracker = {}

registerComponent(AnimationFrameTracker, "AnimationFrameTracker", {"PlayHead"})

function AnimationFrameTracker:setup(firstFrame, lastFrame, fps)
    assert(firstFrame and lastFrame, "AnimationFrameTracker:setup requires 2 arguments, given: " .. tostring(firstFrame) .. ', ' .. tostring(lastFrame)  )
    assert(lastFrame >= firstFrame, "firstFrame needs to come before lastFrame")

    if fps then
        self:setFps(fps)
    end

    self:setRange(firstFrame, lastFrame)
end

function AnimationFrameTracker:reverseSetup()
    return self.firstFrame, self.lastFrame, self.fps
end

function AnimationFrameTracker:awake()
    self.fps = 10
    self.firstFrame = 1
    self.lastFrame = 1
end

--
-- Public API
--

function AnimationFrameTracker:get()
    local seconds = self.actor.PlayHead:get()
    return math.floor(self.firstFrame + self.fps * seconds)
end

function AnimationFrameTracker:set(frame)
    self.actor.PlayHead:set(self:getLengthOfFrameInSeconds() * frame)
end

function AnimationFrameTracker:setRange(firstFrame, lastFrame)
    self.firstFrame = math.floor(firstFrame)
    self.lastFrame = lastFrame

    local numberOfFrames = math.floor(lastFrame) - self.firstFrame + 1
    self.actor.PlayHead:setup(numberOfFrames * self:getLengthOfFrameInSeconds())
end

function AnimationFrameTracker:getLengthOfFrameInSeconds()
    return 1 / self.fps
end

function AnimationFrameTracker:setFps(fps)
    self.fps = fps
end

local Test = require("nx/test")
Test.registerComponentTest(
    AnimationFrameTracker,
    function()
        local Actor = require("nx/game/actor")
        local actor = Actor.new("testActor")
        actor:addComponent(Components.PlayHead)
        local setupArgs = {5, 10, 15}
        local subject = actor:addComponent(AnimationFrameTracker, unpack(setupArgs))

        Test.assert(setupArgs, {subject:reverseSetup()}, "reverseSetup can be fed to setup")

        Test.assert(5, subject:get(), "Get frame at time = 0")

        subject.actor:update(1)
        Test.assert(7, subject:get(), "Get frame after one second")

        subject.actor:update(1)
        Test.assert(10, subject:get(), "Get frame after two seconds, should be end of animation")

        subject.actor:update(subject:getLengthOfFrameInSeconds())
        Test.assert(5, subject:get(), "Get frame after one frame")
    end
)

return AnimationFrameTracker
