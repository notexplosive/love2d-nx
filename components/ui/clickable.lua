local Clickable = {}

registerComponent(Clickable, "Clickable", {"BoundingBox", "Hoverable"})

function Clickable:awake()
    self.currentPressedButton = nil
end

function Clickable:onMousePress(x, y, button, wasRelease, isClickConsumed)
    if not self.actor.visible then
        return
    end

    if not isClickConsumed then
        if self.actor.Hoverable:getHoverConsume() then
            if not wasRelease then
                self.currentPressedButton = button
                self.actor:callForAllComponents("Clickable_onClickStart", button)
                self.actor:scene():consumeClick()
            end

            if wasRelease and self.currentPressedButton then
                self.actor:callForAllComponents("Clickable_onClickOn", button)
                if self.actor:scene() then
                    self.actor:scene():consumeClick()
                end
            end
        else
            if wasRelease then
                self.actor:callForAllComponents("Clickable_onClickOff", button)
            end
        end

        if wasRelease then
            self.currentPressedButton = nil
        end
    end
end

return Clickable
