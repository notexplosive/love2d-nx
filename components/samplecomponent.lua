local SampleComponent = {}

SampleComponent.name = 'SampleComponent'
registerComponent(SampleComponent, 'SampleComponent')

function SampleComponent:awake()
    print('awake')
end

function SampleComponent:start()
    print('start')
end

function SampleComponent:draw(x,y,inFocus)
    love.graphics.print('Hello world!')
end

function SampleComponent:update(dt,inFocus)
    self.dt = dt
end

function SampleComponent:onClick(x,y,button,wasRelease)
    print('onClick',x,y,button,wasRelease)
end

function SampleComponent:onKeyPress(key,scancode,isRepeat)
    print('onKeyPress',key,scancode,isRepeat)
end

function SampleComponent:onMouseMoved(x,y,dx,dy)
    --print('onMouseMoved',x,y,dx,dy)
end

function SampleComponent:onMouseScrolled(x,y)
    print('onMouseScrolled',x,y)
end

return SampleComponent