local FrameStep = {}

registerComponent(FrameStep, "FrameStep")

function FrameStep:onScroll(x, y)
    if gameScene.freeze and y < 0 then
        gameScene.freeze = false
        gameScene:update(1 / 60)
        gameScene.freeze = true
    end
end

return FrameStep
