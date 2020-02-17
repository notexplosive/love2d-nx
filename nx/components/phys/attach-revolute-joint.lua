local AttachRevoluteJoint = {}

registerComponent(AttachRevoluteJoint, "AttachRevoluteJoint")

function AttachRevoluteJoint:setup(actorOrName, collideConnected)
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

    local x, y = self.actor:pos():xy()

    love.physics.newRevoluteJoint(self.actor.Body(), actor.Body(), x, y, collideConnected or false)
end

return AttachRevoluteJoint
