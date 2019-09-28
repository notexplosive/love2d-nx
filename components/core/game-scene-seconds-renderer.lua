local GameSceneSecondsRenderer = {}

registerComponent(GameSceneSecondsRenderer, "GameSceneSecondsRenderer")

function GameSceneSecondsRenderer:awake()
    self.time = 0

    if not self:isInGameScene() then
        self.gameSceneMirror = gameScene:addActor()
        self.gameSceneMirror:addComponent(Components.GameSceneSecondsRenderer)
        self.gameSceneMirror:addComponent(Components.Uneditable)
        self.actor:addComponent(Components.DestroyWith, self.gameSceneMirror)
        self.gameSceneMirror.name = "FrameStep"
    end
end

function GameSceneSecondsRenderer:draw(x, y)
    if not self:isInGameScene() then
        local size = 32
        local cx = math.cos(self:getTime() - math.pi / 2) * size
        local cy = math.sin(self:getTime() - math.pi / 2) * size

        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.circle("fill", x, y, size)
        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.circle("line", x, y, size)
        love.graphics.setColor(0, 0, 0, 1)

        for i = 0, math.pi * 2, math.pi / 5 do
            local dx = math.cos(i) * size
            local dy = math.sin(i) * size
            love.graphics.line(x + dx * 0.9, y + dy * 0.9, x + dx * 0.95, y + dy * 0.95)
        end

        love.graphics.setColor(0.5,0,0,1)
        love.graphics.line(x, y, x + cx * 0.9, y + cy * 0.9)
    end
end

function GameSceneSecondsRenderer:update(dt)
    self.time = self.time + math.pi / 30
end

function GameSceneSecondsRenderer:getTime()
    if self:isInGameScene() then
        return self.time
    else
        return self.gameSceneMirror.GameSceneSecondsRenderer:getTime()
    end
end

function GameSceneSecondsRenderer:isInGameScene()
    return self.actor:scene() == gameScene
end

return GameSceneSecondsRenderer
