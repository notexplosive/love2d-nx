local FileSystem = {}

registerComponent(FileSystem, "FileSystem")

function FileSystem:setup(directory)
    self:setDirectory(directory)
end

function FileSystem:awake()
    self.currentDirectory = ""
    self.directoryItems = {}
end

function FileSystem:refresh()
    self.directoryItems = {}
    for i, item in ipairs(love.filesystem.getDirectoryItems(self.currentDirectory)) do
        self.directoryItems[i] = item
    end

    self.actor:callForAllComponents("FileSystem_onRefresh")
end

--
-- API
--

function FileSystem:getCurrentDirectory()
    return self.currentDirectory
end

function FileSystem:getItems()
    return copyList(self.directoryItems)
end

function FileSystem:setDirectory(directory)
    if directory == '/' then
        directory = ''
    end

    local info = love.filesystem.getInfo(directory)
    if not info then
        debugLog(directory .. ' does not exist!')
        return
    end

    self.currentDirectory = string.join(directory:split('/'), "/")
    self:refresh()
end

function FileSystem:setDirectoryLocal(directory)
    assert(directory, "setDirectoryLocal takes one argument")
    local newDirectory = self.currentDirectory .. "/" .. directory

    self:setDirectory(newDirectory)
    return newDirectory
end

function FileSystem:upOneLevel()
    local splitDirectory = self.currentDirectory:split("/")
    splitDirectory[#splitDirectory] = nil
    local newDirectory = string.join(splitDirectory, "/")
    self:setDirectory(newDirectory)
    return newDirectory
end

return FileSystem
