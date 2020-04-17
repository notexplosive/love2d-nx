Components = {}

function registerComponent(componentClass, name, deps)
    if deps then
        assert(type(deps) == "table", "Dependencies need to be in a table (" .. name .. ")")
    end
    componentClass.name = componentClass.name or name
    componentClass.dependencies = deps or {}

    function componentClass.create_object()
        return newObject(componentClass)
    end

    function componentClass.reverseSetupSafe(self)
        if not self.setup then
            return nil
        end

        if self.reverseSetup then
            return self:reverseSetup()
        end

        assert(false, self.name .. " has setup but no reverseSetup")
    end

    function componentClass.supportsReverseSetup(self)
        if self.setup then
            return self.reverseSetup ~= nil
        end

        return true
    end

    function componentClass.destroy(self)
        if self._componentDestroyed then
            return
        end

        if self.actor then
            self.actor:removeComponent(componentClass)
        end
    end

    Components[componentClass.name] = componentClass
end

function requireComponents(path)
    for i, v in ipairs(love.filesystem.getDirectoryItems(path)) do
        local filename = path .. v
        if love.filesystem.getInfo(filename).type == "file" then
            moduleName = filename:split(".")[1]
            require(moduleName)
        else
            -- Recurse into sub-directory
            requireComponents(filename .. "/")
        end
    end
end

local Test = require("nx/test")
Test.run(
    "Component",
    function()
        local Actor = require("nx/game/actor")
        local BoundingBox = require("nx/components/core/bounding-box")
        local actor = Actor.new()
        local bbox = actor:addComponent(BoundingBox)
        Test.assert(bbox, actor.BoundingBox, "Component is equivalent to the return value of addComponent")
        actor.BoundingBox:destroy()
        Test.assert(nil, actor.BoundingBox, "Component is nil after destroy")
    end
)

-- Recurse into each of these folders and call require() on all of them
requireComponents("nx/components/")
--requireComponents("mygame/")
