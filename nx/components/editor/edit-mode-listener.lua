local EditModeListener = {}

registerComponent(EditModeListener, "EditModeListener")

function EditModeListener:enableEditor()
    for i, actor in ipairs(self.actor:scene():getAllActors()) do
        if not actor.Uneditable and not actor.Editable then
            actor:addComponent(Components.Editable)
        end
    end
end

function EditModeListener:disableEditor()
    for i, actor in self.actor:scene():eachActorWith(Components.Editable) do
        actor:removeComponent(Components.Editable)
    end
end

return EditModeListener
