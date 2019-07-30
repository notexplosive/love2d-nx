local GroupVisibility = {}

registerComponent(GroupVisibility, "GroupVisibility", {"GroupHelpers"})

function GroupVisibility:setup(groupName)
    self.groupName = groupName
end

function GroupVisibility:update(dt)
    for i, actor in ipairs(self.actor.GroupHelpers:getGroup(self.groupName)) do
        actor.visible = self.actor.visible
    end
end

return GroupVisibility
