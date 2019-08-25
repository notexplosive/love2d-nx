local Lensable = {}

registerComponent(Lensable, "Lensable")

function Lensable:awake()
    self.preferLens = false
    self.lensed = false
end

function Lensable:update(dt)
    local intersects = false
    local Lensabled = false

    for i, actor in self.actor:scene():eachActorWith(Components.LensRect) do
        local myRect = self.actor.BoundingBox:getRect()
        local lensRect = actor.BoundingBox:getRect()
        local intersectionRect = lensRect:getIntersection(myRect)

        if intersectionRect:area() > 0 then
            intersects = true
        end

        local p1, p2 = myRect:asTwoVectors()
        if lensRect:isVectorWithin(p1) and lensRect:isVectorWithin(p2) then
            Lensabled = true
            self.preferLens = false
        end
    end

    if not intersects then
        self.preferLens = true
    end

    self.lensed = Lensabled or (intersects and self.preferLens)
end

function Lensable:draw(x, y)
    if self.
    lensed then
        love.graphics.setColor(1, 0, 0,0.5)
    else
        love.graphics.setColor(0, 0, 1,0.5)
    end
    love.graphics.rectangle("fill", self.actor.BoundingBox:getRect():xywh())
end

function Lensable:isLensed()
    return self.lensed
end

return Lensable
