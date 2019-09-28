local Destroyable = {}

registerComponent(Destroyable, "Destroyable", {"Keybind"})

function Destroyable:setup(keybind)
    self.keybind = keybind
end

function Destroyable:reverseSetup()
    return self.keybind
end

function Destroyable:Keybind_onPress(key)
    if key == self.keybind and not wasRelease and self.actor.Selectable:selected() then
        self.actor:destroy()
    end
end

return Destroyable
