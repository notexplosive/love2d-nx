local DestroyWith = {}

registerComponent(DestroyWith,'DestroyWith')

function DestroyWith:setup(targetActor)
    append(self.list,targetActor)
end

function DestroyWith:awake()
    self.list = {}
end

function DestroyWith:onDestroy()
    for i,actor in ipairs(self.list) do
        actor:destroy()
    end
end

return DestroyWith