local BouncyBall = {}

registerComponent(BouncyBall, "BouncyBall")

function BouncyBall:awake()
    self.actor:Fixtures():setRestitution(0.5) --let the ball bounce
end

return BouncyBall
