local OnClickDo = {}

registerComponent(OnClickDo,'OnClickDo')

function OnClickDo:setup(func)
    self.func = func
end

function OnClickDo:Clickable_onClickOn(button)
    if button == 1 then
        self.func()
    end
end

return OnClickDo