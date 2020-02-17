local AttachDistanceJoint = {}

registerComponent(AttachDistanceJoint, "AttachDistanceJoint")

function AttachDistanceJoint:setup(actorOrName)
    local name
    if type(actorOrName) == "string" then
        name = actorOrName
    end

    local actor
    if name then
        actor = self.actor:scene():getActor(name)
    else
        actor = actorOrName
    end

    local x1, y1 = self.actor:pos():xy()
    local x2, y2 = actor:pos():xy()

    love.physics.newDistanceJoint(self.actor.Body(), actor.Body(), x1, y1, x2, y2, true)
end

return AttachDistanceJoint
