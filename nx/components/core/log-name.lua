local LogName = {}

registerComponent(LogName,'LogName')

function LogName:awake()
    debugLog(self.actor.name)
    print(self.actor.name)
end

function LogName:draw(x,y)
    
end

function LogName:update(dt)
    
end

return LogName