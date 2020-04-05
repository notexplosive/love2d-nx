local DestroyAtRandomTime = {}

registerComponent(DestroyAtRandomTime, "DestroyAtRandomTime")

function DestroyAtRandomTime:update()
    if love.math.random() < 0.01 then
        self.actor:destroy()
    end
end

return DestroyAtRandomTime
