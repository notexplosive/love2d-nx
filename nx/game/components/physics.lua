local Physics = {}

registerComponent(Physics,'Physics')

function Physics.create()
    return newObject(Physics)
end

function Physics:awake()
    
end

function Physics:update(dt)
    
end

function Physics:onHitEdge(left,right,top,bottom)
    
end

return Physics