local SceneGraphRenderer = {}

registerComponent(SceneGraphRenderer, "SceneGraphRenderer")

function SceneGraphRenderer:setup(indexOfTargetScene)
    self.indexOfTargetScene = indexOfTargetScene
end

function SceneGraphRenderer:start()
    self.actor:addComponent(Components.TreeNode)
    self.targetScene = sceneLayers:at(self.indexOfTargetScene)

    assert(self.targetScene ~= self.actor:scene(), "SceneGraphRenderer cannot target current scene, it'll blow up")
end

function SceneGraphRenderer:update(dt)
    self.actor.TreeNode:clear()
    for i, actor in self.targetScene:eachActor() do
        -- Todo: actor.name -> actor
        local node = self.actor.TreeNode:addNode(actor.name)
    end
end

return SceneGraphRenderer
