local FollowActor = {}

registerComponent(FollowActor,'FollowActor')

function FollowActor:setup(targetActor)
    self.targetActor = targetActor
end

function FollowActor:update(dt)
    if self.targetActor and not self.targetActor.isDestroyed then
        self.actor:setPos(self.targetActor:pos())
    end
end

return FollowActor