local MemoryTracker = {}

registerComponent(MemoryTracker, "MemoryTracker")

local font = love.graphics.newFont(12)
local width, height = 300, 200
local rollingAverageSize = 10

function MemoryTracker:setup()
    self.usageList = List.new()
    self.usageListPosition = 1
    for i = 1, width do
        self.usageList:add(0)
    end

    self.rollingAverageList = List.new()
    self.averageListPosition = 1
    for i = 1, rollingAverageSize do
        self.rollingAverageList:add(0)
    end

    self.currentMemoryUsage = 0
end

function MemoryTracker:draw(x, y)
    if DEBUG then
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.rectangle("fill", x, y, width, height)

        love.graphics.setColor(0, 0, 0, 1)

        local points = List.new()
        for i = 1, width do
            local usage = height - self.usageList:at(i) / 20
            points:add(Vector.new(x + i, y + clamp(usage, 0, height)))
        end

        for i = 2, points:length() do
            local prevPoint = points:at(i - 1)
            local currPoint = points:at(i)
            if i < self.usageListPosition then
                love.graphics.setColor(0, 0, 0, 1)
            else
                love.graphics.setColor(1, 0, 0, 1)
            end
            love.graphics.line(prevPoint.x, prevPoint.y, currPoint.x, currPoint.y)
        end

        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.rectangle("line", x, y, width, height)
        love.graphics.setFont(font)
        love.graphics.print(math.floor(self.currentMemoryUsage), x, y)
    end
end

function MemoryTracker:update(dt)
    if self.averageListPosition < rollingAverageSize then
        self.averageListPosition = self.averageListPosition + 1
        self.rollingAverageList:setAt(self.averageListPosition, collectgarbage("count"))
    else
        self.averageListPosition = 1
        local total = 0
        for i, n in self.rollingAverageList:each() do
            total = total + n
        end

        local average = total / rollingAverageSize
        self.currentMemoryUsage = average

        self.usageListPosition = self.usageListPosition % width + 1
        self.usageList:setAt(self.usageListPosition, average)
    end
end

return MemoryTracker
