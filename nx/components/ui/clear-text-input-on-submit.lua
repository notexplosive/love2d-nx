local ClearTextInputOnSubmit = {}

registerComponent(ClearTextInputOnSubmit, "ClearTextInputOnSubmit", {"TextInput"})

function ClearTextInputOnSubmit:TextInput_onSubmit()
    self.actor.TextInput:setText("")
end

return ClearTextInputOnSubmit
