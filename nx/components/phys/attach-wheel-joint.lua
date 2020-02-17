local AttachWheelJoint = {}

registerComponent(AttachWheelJoint, "AttachWheelJoint")

function AttachWheelJoint:setup(actorOrName)
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

    self.joint = love.physics.newWheelJoint(self.actor.Body(), actor.Body(), x1, y1, 1, 0, false)
    self.joint:setSpringFrequency(100)
end

return AttachWheelJoint
