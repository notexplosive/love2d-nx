local Hoverable = {}

registerComponent(Hoverable, "Hoverable")

function Hoverable:awake()
    self.wasHovered = false
end

function Hoverable:onMouseMove(x, y, dx, dy, isConsumed)
    self.cachedMousePos = Vector.new(x, y)

    if isConsumed then
        if self.wasHovered then
            self.actor:callForAllComponents("Hoverable_onUnhover")
            self.wasHovered = false
        end
        return
    end

    if self:getHover() then
        self.actor:callForAllComponents("Hoverable_onHover")
        self.actor:scene():consumeHover()
        self.wasHovered = true
    else
        self.actor:callForAllComponents("Hoverable_onUnhover")
        self.wasHovered = false
    end
end

function Hoverable:getHoverOfPoint(v, y)
    local x, y = Vector.new(v, y):xy()
    return self.actor.BoundingBox:getRect():isVectorWithin(x, y)
end

function Hoverable:getHover()
    return self:getHoverOfPoint(self.cachedMousePos)
end


local Test = require("nx/test")
Test.run(
    "Hoverable",
    function()
        local Actor = require("nx/game/actor")
        local scene = require("nx/game/scene").new()

        local actor1 = scene:addActor()
        actor1:addComponent(Components.BoundingBox,100,100)
        actor1:addComponent(Components.Hoverable)
        local actor2 = scene:addActor()
        actor2:addComponent(Components.BoundingBox,100,100)
        actor2:addComponent(Components.Hoverable)

        actor2:setPos(50,50)

        scene:onMouseMove(60,60)
        Test.assert(true,actor2.Hoverable.wasHovered,"Top actor was hovered")
        Test.assert(false,actor1.Hoverable.wasHovered,"Bottom actor was not hovered")
    end
)

return Hoverable
