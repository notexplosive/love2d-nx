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

    function componentClass.destroy(self)
        if self._componentDestroyed then
            return
        end

        if self.actor then
            if self.onDestroy then
            --self:onDestroy()
            end
            self.actor:removeComponent(componentClass)
        end

        self._componentDestroyed = true
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

-- Recurse into each of these folders and call require() on all of them
requireComponents("nx/components/")
