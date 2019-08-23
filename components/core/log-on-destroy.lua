local LogOnDestroy = {}

registerComponent(LogOnDestroy,'LogOnDestroy')

function LogOnDestroy:setup(msg)
    self.msg = msg
end

function LogOnDestroy:awake()
    self.msg = ""
end

function LogOnDestroy:onDestroy()
    debugLog(self.actor.name .. ' destroyed', msg)
end

return LogOnDestroy