local ClassicNinePatch = {}

registerComponent(ClassicNinePatch, "ClassicNinePatch", {"BoundingBox"})

function ClassicNinePatch:setup(imageName)
    self.sprite = Assets[imageName]
end

function ClassicNinePatch:draw(x, y)
    local width, height = self.actor.BoundingBox:getDimensions()

    width = width - 16 - width % 16
    height = height - 16 - height % 16
    
    for dx = 0, width, 16 do
        for dy = 0, height, 16 do
            local quad = 4
            if dy == 0 then
                quad = 2
                if dx == 0 then
                    quad = 1
                end
                if dx == width then
                    quad = 4
                end
            elseif dx == 0 then
                quad = 5
                if dy == height then
                    quad = 13
                end
            elseif dx == width then
                quad = 8
                if dy == height then
                    quad = 16
                end
            elseif dy == height then
                quad = 14
            else
                -- fill in the middle
                quad = 6
            end
            local drawPos = Vector.new(dx + x, dy + y)
            self.sprite:draw(quad, drawPos.x, drawPos.y, 0, 0)
        end
    end
end

return ClassicNinePatch
