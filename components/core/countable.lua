local Countable = {}

registerComponent(Countable,'Countable')

function Countable:setup(key)
    self.key = key
    self.actor:scene():getFirstComponent(Components.Counter):increment(key)
end

function Countable:start()
    assert(self.key,"Setup was not run")
end

function Countable:onDestroy()
    self.actor:scene():getFirstComponent(Components.Counter):decrement(key)
end

return Countable