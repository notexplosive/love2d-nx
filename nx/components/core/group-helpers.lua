local GroupHelpers = {}

registerComponent(GroupHelpers,'GroupHelpers')

-- todo: become GroupOwner?
-- or maybe GroupOwner insntiates GroupHelpers and also stores a groupname?

function GroupHelpers:getGroup(name)
    local actors = {}

    for i, actor in ipairs(self.actor:scene():getAllActorsWithBehavior(Components.Group)) do
        if actor.Group.name == name then
            append(actors, actor)
        end
    end

    return actors
end

return GroupHelpers