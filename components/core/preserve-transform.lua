local PreserveTransform = {}

registerComponent(PreserveTransform, "PreserveTransform")

function PreserveTransform:awake()
    self:save()
end

function PreserveTransform:save()
    self.savedPos = self.actor:pos()
    self.savedAngle = self.actor:angle()
end

function PreserveTransform:load()
    self.actor:setPos(self.savedPos)
    self.actor:setAngle(self.savedAngle)
end

return PreserveTransform