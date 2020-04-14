local State = require("nx/state")
local StateCheckbox = {}

registerComponent(StateCheckbox, "StateCheckbox")

function StateCheckbox:setup(flagName, label)
    self.actor:addComponent(Components.BoundingBox)
    self.actor:addComponent(Components.Hoverable)
    self.actor:addComponent(Components.ShowMousePointerHandOnHover)
    self.actor:addComponent(Components.Clickable)
    self.actor:addComponent(Components.CheckboxToggle, State:getBool(flagName), label)

    self.flagName = flagName
end

-- Potentially move this to its own component?
function StateCheckbox:apply()
    State:persist(self.flagName, self.actor.CheckboxToggle:getState())
end

return StateCheckbox
