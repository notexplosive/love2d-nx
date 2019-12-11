local TextToastOnDestroy = {}

registerComponent(TextToastOnDestroy,'TextToastOnDestroy')

function TextToastOnDestroy:setup(text)
    self.text = text
end

function TextToastOnDestroy:awake(text)
    self.text = "GOAT IN!"
end

function TextToastOnDestroy:onDestroy()
    local toast = desktopScene:addActor("Toast")
    toast:setPos(Vector.new(love.graphics.getDimensions())/2)
    toast:addComponent(Components.TextToast):setup(self.text)
end

return TextToastOnDestroy