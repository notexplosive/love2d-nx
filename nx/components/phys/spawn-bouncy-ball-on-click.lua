local SpawnBouncyBallOnClick = {}

registerComponent(SpawnBouncyBallOnClick, "SpawnBouncyBallOnClick")

function SpawnBouncyBallOnClick:awake()
end

function SpawnBouncyBallOnClick:draw(x, y)
end

function SpawnBouncyBallOnClick:onMousePress(x, y, button, wasRelease)
    if not wasRelease then
        if button == 1 then
            local actor = self.actor:scene():addActor()
            actor:setPos(x, y)
            actor:addComponent(Components.Body, "dynamic", 1)
            actor:addComponent(Components.CircleShape, 15)
        end
    end
end

return SpawnBouncyBallOnClick
