local SelectOnNotify = {}

registerComponent(SelectOnNotify, "SelectOnNotify", {"Selectable"})

function SelectOnNotify:setup(msg)
    self.msg = msg
end

function SelectOnNotify:start()
    assert(self.msg)
end

function SelectOnNotify:onNotify(msg)
    if msg == self.msg then
        self.actor.Selectable:select()
    end
end

return SelectOnNotify
