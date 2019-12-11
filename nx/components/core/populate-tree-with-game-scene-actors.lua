local PopulateTreeWithGameSceneActors = {}

registerComponent(PopulateTreeWithGameSceneActors, "PopulateTreeWithGameSceneActors", {"TreeNode"})

function PopulateTreeWithGameSceneActors:update(dt)
    self.actor.TreeNode:clear()
    for i, actor in gameScene:eachActor() do
        -- Todo: actor.name -> actor
        local node = self.actor.TreeNode:addNode(actor.name)
    end
end

return PopulateTreeWithGameSceneActors
