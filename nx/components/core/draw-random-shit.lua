local DrawRandomShit = {}

registerComponent(DrawRandomShit, "DrawRandomShit")

function DrawRandomShit:awake()
end

function DrawRandomShit:draw(x, y)
    if self.actor.Canvas then
        self.actor.Canvas:canvasDraw(
            function(width,height)
                local x = width * love.math.random()
                local y = height * love.math.random()
                local r = 5 + love.math.random() * 20
                love.graphics.setColor(love.math.random(), 0, 1, 0.5)
                love.graphics.circle("fill", x, y, r)
            end
        )
    end
end

function DrawRandomShit:update(dt)
end

return DrawRandomShit
