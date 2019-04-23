local SampleComponent = {}

SampleComponent.name = 'SampleComponent'
registerComponent(SampleComponent, 'SampleComponent')

function SampleComponent:awake()
    print('awake')
end

function SampleComponent:start()
    print('start')
end

function SampleComponent:draw(x,y)
    love.graphics.print('Hello world!')
end

function SampleComponent:update(dt)
    self.dt = dt
end

function SampleComponent:onMousePress(x,y,button,wasRelease)
    print('onMousePress',x,y,button,wasRelease)
end

function SampleComponent:onKeyPress(key,scancode,isRepeat)
    print('onKeyPress',key,scancode,isRepeat)
end

function SampleComponent:onMouseMove(x,y,dx,dy)
    --print('onMouseMove',x,y,dx,dy)
end

function SampleComponent:onMouseScrolled(x,y)
    print('onMouseScrolled',x,y)
end

return SampleComponent