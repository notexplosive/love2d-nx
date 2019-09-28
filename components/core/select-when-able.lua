local SelectWhenAble = {}

registerComponent(SelectWhenAble,'SelectWhenAble')

function SelectWhenAble:update(dt)
    if self.actor.Selectable then
        self.actor.Selectable:select()
        self:destroy()
    end
end

return SelectWhenAble