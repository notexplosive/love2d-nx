local CircleCollider = {}

CircleCollider.name = 'circleCollider'
registerComponent(CircleCollider)

function CircleCollider.create()
    return newObject(CircleCollider)
end

function CircleCollider:awake()
    self.actor.collider = self -- ALL COLLIDERS SHOULD USE THIS AS A WAY TO IDENTIFY THEM
    self.radius = 16
end

function CircleCollider:draw()
    
end

function CircleCollider:update(dt)
    self.collidedThisFrame = false
    if self.actor.scene then
        for i,actor in ipairs(self.actor.scene:getAllActors()) do
            if actor ~= self.actor and actor.collider then
                self:customCollide(actor.collider)
                self:circleCollide(actor.collider)
            end
        end
    end
end

function CircleCollider:circleCollide(otherCollider)
    if otherCollider.type == CircleCollider then
        local distance = (otherCollider.actor.pos - self.actor.pos):length()
        if distance < self.radius + otherCollider.radius then
            self.collidedThisFrame = true
            self:onCollide(otherCollider)
        end
    end
end

function CircleCollider:onCollide(otherCollider)
    -- To be overridden by client code
end

-- TODO: move this to "empty collider", also rename CircleCollider to CircleCollider
function CircleCollider:customCollide(otherCollider)
    -- overrideable, supposed to call onCollide
end

return CircleCollider