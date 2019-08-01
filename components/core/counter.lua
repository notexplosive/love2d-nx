local Counter = {}

registerComponent(Counter,'Counter')

function Counter:awake()
    self.values = {}
end

function Counter:get(key)
    return self.values[key]
end

function Counter:increment(key)
    self.values[key] = self.values[key] + 1
end

function Counter:decrement(key)
    self.values[key] = self.values[key] - 1
end

return Counter