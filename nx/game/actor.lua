local Actor = {}

function Actor.new(name,star)
    assert(name ~= nil,"Must provide a name for actor")
    local self = newObject(Actor)
    self.name = name
    self.pos = Vector.new()
    self.angle = 0
    self.components = {}
    self.boundingWidth = 32
    self.boundingHeight = 32
    self.boundingOffset = Vector.new(0,0)
    self.visible = true
    self.useCustomBoundingBox = false

    function self:scene()
        assert(self,'use Actor:scene() and not Actor.scene()')
        return self.originalScene
    end
    -- Used for lens logic
    self.originalScene = nil
    -- The scene that summoned this actor
    self.parentScene = nil
    self.star = star or false

    return self
end

-- called by scene
function Actor:sceneUpdate(dt,inFocus)
    for i,component in ipairs(self.components) do
        if component.update and (not component.needsFocusToUpdate or inFocus) and self:scene() then
            component:update(dt,inFocus)
        end
    end
end

-- called by scene
function Actor:start()
    for i,component in ipairs(self.components) do
        if component.start then
            component:start()
        end
    end
end

-- called by scene
function Actor:draw(inFocus,x,y)
    if x == nil then
        x,y = self.pos.x,self.pos.y
    end
    for i,component in ipairs(self.components) do
        if component.draw and (not component.needsFocusToDraw or inFocus) then
            component:draw(x,y,inFocus)
        end
    end
end

-- called by scene
function Actor:keyPressed(key,scancode)
    for i,component in ipairs(self.components) do
        if component.keyPressed then
            component:keyPressed(key,scancode)
        end
    end
end

-- called by scene
function Actor:textEntered(text)
    for i,component in ipairs(self.components) do
        if component.textEntered then
            component:textEntered(text)
        end
    end
end

-- Called by scene
function Actor:onClick(x,y,button,wasRelease)
    for i,component in ipairs(self.components) do
        if component.onClick then
            component:onClick(x,y,button,wasRelease)
        end
    end
end

-- called by the scene
function Actor:onDestroy()
    for i,component in ipairs(self.components) do
        if component.onDestroy then
            component:onDestroy()
        end
    end
end

-- called by colliders
function Actor:onCollide(otherActor)
    for i,component in ipairs(self.components) do
        if component.onCollide then
            component:onCollide(otherActor)
        end
    end
end

-- called by scene OR by others
function Actor:destroy()
    self:onDestroy()
    self:removeFromScene()
end

-- called by lens, doesn't technically "destroy" the actor
function Actor:removeFromScene()
    if self:scene() then
        local index = self:scene():getActorIndex(self)
        self:scene().actors[index] = nx_null
        for i = index, #self:scene().actors do
            self:scene().actors[i] = self:scene().actors[i+1]
        end
        self.originalScene = nil
    end
end

-- a component is anything that has a draw function OR and update function
function Actor:addComponent(componentClass)
    assert(componentClass,"Nil component")
    assert(componentClass.name,"Component needs a name")
    assert(componentClass.update or componentClass.draw,componentClass.name .. ' does not have update or draw')
    local component = componentClass.create()
    component.actor = self

    self[component.name] = component
    
    append(self.components,component)

    if component.awake then
        component:awake()
    end
    
    return component
end

function Actor:move(velocity)
    assert(velocity.type == Vector)
    self.pos = self.pos + velocity
end

function Actor:setPosition(pos)
    self.pos = pos:clone()
end

function Actor:getBoundingBox()
    if self.spriteRenderer and (self.boundingOffset.x == 0 or self.boundingOffset.y == 0) and not self.useCustomBoundingBox then
        return self.spriteRenderer:getBoundingBox()
    end
    return self.pos.x - self.boundingOffset.x,self.pos.y - self.boundingOffset.y,self.boundingWidth,self.boundingHeight
end

function Actor:setBoundingBoxDimensions(w,h)
    self.boundingWidth = w
    self.boundingHeight = h
end

function Actor:isWithinBoundingBox(x,y)
    return isWithinBox(x,y,self:getBoundingBox())
end

function Actor:isCenterOutOfBounds()
    if self.scene then
        return not isWithinBox(self.pos.x,self.pos.y,self:scene():getBounds())
    end

    print(self.actor.name .. ' bounds check not applicable, no scene')
    return nil
end

function Actor:isOutOfBounds()
    if self.scene then
        local x,y,w,h = self:getBoundingBox()
        local x2,y2 = x+w,y+h
        return 
            not isWithinBox(x,y,self:scene():getBounds()) and
            not isWithinBox(x,y2,self:scene():getBounds()) and
            not isWithinBox(x2,y,self:scene():getBounds()) and
            not isWithinBox(x2,y2,self:scene():getBounds())
    end

    print(self.actor.name .. ' bounds check not applicable, no scene')
end

return Actor