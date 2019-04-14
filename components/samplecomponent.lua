local SampleComponent = {}

SampleComponent.name = 'SampleComponent'
registerComponent(SampleComponent)

function SampleComponent.create()
    return newObject(SampleComponent)
end

function SampleComponent:awake()
    print('awake')
    self.actor.pos.x = 20
end

function SampleComponent:start()
    print('start')
end

function SampleComponent:draw(x,y,inFocus)
    love.graphics.print(self.dt,x,y)
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
    print('onMouseMoved',x,y,dx,dy)
end

function SampleComponent:onMouseScrolled(x,y)
    print('onMouseScrolled',x,y)
end

return SampleComponent