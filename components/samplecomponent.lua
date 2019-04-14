local SampleComponent = {}

SampleComponent.name = 'SampleComponent'
registerComponent(SampleComponent)

function SampleComponent.create()
    return newObject(SampleComponent)
end

function SampleComponent:awake()
    print('awake')
end

function SampleComponent:draw(x,y,inFocus)
    love.graphics.print(self.dt)
end

function SampleComponent:update(dt,inFocus)
    self.dt = dt
end

function SampleComponent:onClick(x,y,button,wasRelease)
    print('click',x,y,button,wasRelease)
end

function SampleComponent:onKeyPress(key,scancode,wasRepeat)
    print('keypress',key,scancode,wasRepeat)
end

return SampleComponent