local Fixtures = {}

registerComponent(Fixtures, "Fixtures")

function Fixtures:setup(fixture)
    self:add(fixture)
end

function Fixtures:__call()
    return unpack(self.fixtures or {})
end

function Fixtures:add(fixture)
    self.fixtures = self.fixtures or {}
    append(self.fixtures, fixture)
end

return Fixtures
