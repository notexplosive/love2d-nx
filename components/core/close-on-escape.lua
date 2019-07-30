local CloseOnEscape = {}

registerComponent(CloseOnEscape,'CloseOnEscape')

function CloseOnEscape:awake()
    
end

function CloseOnEscape:draw(x,y)
    
end

function CloseOnEscape:onKeyPress(key)
    if key == 'escape' then
        love.event.quit(0)
    end
end

return CloseOnEscape