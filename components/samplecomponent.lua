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
    love.graphics.print('Hello world')
end

function SampleComponent:update(dt,inFocus)
    print(dt)
end

return SampleComponent