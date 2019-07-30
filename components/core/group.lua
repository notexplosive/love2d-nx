local Group = {}

registerComponent(Group, "Group")

function Group:setup(name)
    self.name = name
end

return Group