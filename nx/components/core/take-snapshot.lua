local TakeSnapshot = {}

registerComponent(TakeSnapshot, "TakeSnapshot")

function TakeSnapshot:setup(seconds)
    self.timer = seconds
end

function TakeSnapshot:awake()
    self.timer = 1
end

function TakeSnapshot:start()
    debugLog("SNAPSHOT enabled")
    self:takeSnapshot()
end

function TakeSnapshot:update(dt)
    self.timer = self.timer - dt
end

function TakeSnapshot:draw()
    if self.timer < 0 then
        self:takeSnapshot()
        self:destroy()
    end
end

function TakeSnapshot:takeSnapshot()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(love.graphics.newFont(24))
    love.graphics.print(os.date("%c"))
    love.filesystem.createDirectory("snapshots")
    local screenshot = love.graphics.captureScreenshot("snapshots/" .. os.time() .. ".png")
    debugLog("snapshot taken")
end

return TakeSnapshot
