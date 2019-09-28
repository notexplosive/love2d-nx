local FileSystem = {}

registerComponent(FileSystem, "FileSystem")

function FileSystem:setup(directory)
    if not self:directoryExists(directory) then
        self:createDirectory(directory)
    end

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

function FileSystem:getDirectory()
    return self.currentDirectory
end

function FileSystem:getItems()
    return copyList(self.directoryItems)
end

function FileSystem:createDirectory(directory)
    love.filesystem.createDirectory(directory)
end

function FileSystem:directoryExists(directory)
    if directory == "/" then
        directory = ""
    end

    local info = love.filesystem.getInfo(directory)
    return info ~= nil
end

function FileSystem:setDirectory(directory)
    if directory == "/" then
        directory = ""
    end

    local info = love.filesystem.getInfo(directory)
    if not info then
        debugLog(directory .. " does not exist!")
        return
    end

    self.currentDirectory = string.join(directory:split("/"), "/")
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

function FileSystem:write(fileName, data)
    local path = self:getPath(fileName)
    love.filesystem.write(path, data)
end

function FileSystem:read(fileName)
    assert(fileName,"no fileName supplied")
    local path = self:getPath(fileName)
    return love.filesystem.read(path)
end

function FileSystem:getPath(fileName)
    return self.currentDirectory .. "/" .. fileName
end

local Test = require("nx/test")
Test.registerComponentTest(
    FileSystem,
    function()
        local Actor = require("nx/game/actor")
        local actor = Actor.new("testActor")

        local subject = actor:addComponent(FileSystem)

        subject:setDirectory("components/core")
        Test.assert(#love.filesystem.getDirectoryItems(subject:getDirectory()), #subject:getItems(), "Count files")

        subject:upOneLevel()
        Test.assert("components", subject:getDirectory(), "Up one level")

        subject:upOneLevel()
        Test.assert("", subject:getDirectory(), "Up one level to root directory")

        subject:upOneLevel()
        Test.assert("", subject:getDirectory(), "Up one level past root directory")

        subject:setDirectoryLocal("nx")
        subject:setDirectoryLocal("game")
        Test.assert("nx/game", subject:getDirectory(), "setDirectoryLocal")
    end
)

return FileSystem
