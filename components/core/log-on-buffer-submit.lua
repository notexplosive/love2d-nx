local LogOnBufferSubmit = {}

registerComponent(LogOnBufferSubmit,'LogOnBufferSubmit')

function LogOnBufferSubmit:TextBuffer_onSubmit(text)
    debugLog(text)
end

return LogOnBufferSubmit