nx_AllObjects = {}
nx_AllDrawableObjects = {}
nx_null = {NULL = "NULL"}

function newObject(obj_t, addToList)
    object = {}
    setmetatable(object, obj_t)

    obj_t.__index = obj_t
    object.type = obj_t

    if addToList then
        object.listIndex = #nx_AllObjects + 1
        nx_AllObjects[object.listIndex] = object
        nx_AllDrawableObjects[object.listIndex] = object

        function object:destroy()
            nx_AllObjects[self.listIndex] = nx_null
            nx_AllDrawableObjects[getDrawIndex(self)] = nx_null
        end

        if obj_t.getAll == nil then
            function obj_t.getAll()
                local result = {}
                for i, v in ipairs(nx_AllObjects) do
                    if v.type == obj_t then
                        append(result, v)
                    end
                end
                return result
            end
        end

        if obj_t.getAllDraw == nil then
            function obj_t.getAllDraw()
                local result = {}
                for i, v in ipairs(nx_AllDrawableObjects) do
                    if v.type == obj_t then
                        append(result, v)
                    end
                end
                return result
            end
        end
    end

    return object
end

local Vector = require("nx/vector")

gCameraPos = Vector.new(0, 0)
gCameraZoom = 1

function getDrawPos(worldx, worldy)
    if type(worldx) ~= "number" and worldx.type == Vector then
        local vec = worldx
        return Vector.new(getDrawPos(vec.x, vec.y))
    end

    local x = (worldx + (gCameraPos.x)) * gCameraZoom
    local y = (worldy + (gCameraPos.y)) * gCameraZoom

    return x, y
end

function getDrawIndex(obj)
    for i, v in ipairs(nx_AllDrawableObjects) do
        if obj == v then
            return i
        end
    end

    return nil
end

-- math
function clamp(num, low, high)
    if num < low then
        return low, true, false
    end

    if num > high then
        return high, false, true
    end

    return num, false, false
end

-- Generic list utilities
function append(table, element)
    table[#table + 1] = element
end

function copyList(list)
    local copy = {}
    for i, v in ipairs(list) do
        append(copy, v)
    end
    return copy
end

function copyReversed(list)
    local copy = {}
    local sz = 1
    for i=#list,1,-1 do
        copy[sz] = list[i]
        sz = sz + 1
    end
    return copy
end

function deleteAt(table, index)
    for i = index, #table do
        table[i] = table[i + 1]
    end
    return table[index]
end

function deleteFromList(table, element)
    local index = getIndex(table, element)
    if index then
        return deleteAt(table, index)
    end
    return nil
end

function getIndex(table, element)
    for i, v in ipairs(table) do
        if v == element then
            return i
        end
    end
    return nil
end

function shuffle(table)
    local size = #table
    for i = size, 1, -1 do
        local rand = love.math.random(i)
        table[i], table[rand] = table[rand], table[i]
    end
    return table
end

function contains(table, element)
    for i, v in ipairs(table) do
        if v == element then
            return true
        end
    end
    return false
end

-- Generic utility to get a random element of an array
function getRandom(table)
    return table[math.random(#table)]
end

-- Taken from SuperFastNinja on StackOverflow
function string.split(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t = {}
    i = 1
    for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end

function string.join(table, joiner)
    joiner = joiner or ''
    assert(type(joiner) == 'string')

    local result = ''
    local len = #table
    for i,v in ipairs(table) do
        result = result .. v
        if i ~= len then
            result = result .. joiner
        end
    end

    return result
end

function string.charAt(str, i)
    return string.sub(str, i, i)
end

-- Taken from lhf on StackOverflow
function getKeys(table)
    local keyset = {}
    local n = 0

    for k, v in pairs(table) do
        n = n + 1
        keyset[n] = k
    end

    return keyset
end

function collide(actor1, actor2)
    if actor1 == actor2 then
        return false
    end

    local x, y, w, h = actor1:getBoundingBox()
    local x2, y2 = x + w, y + h

    local a =
        isWithinBox(x, y, actor2:getBoundingBox()) or isWithinBox(x, y2, actor2:getBoundingBox()) or
        isWithinBox(x2, y, actor2:getBoundingBox()) or
        isWithinBox(x2, y2, actor2:getBoundingBox())

    local x, y, w, h = actor2:getBoundingBox()
    local x2, y2 = x + w, y + h

    local b =
        isWithinBox(x, y, actor1:getBoundingBox()) or isWithinBox(x, y2, actor1:getBoundingBox()) or
        isWithinBox(x2, y, actor1:getBoundingBox()) or
        isWithinBox(x2, y2, actor1:getBoundingBox())

    return a or b
end

-- From stackoverflow 
-- https://stackoverflow.com/questions/31730923/check-if-point-lies-in-polygon-lua
function insidePolygon(polygon, point)
    local oddNodes = false
    local j = #polygon
    for i = 1, #polygon do
        if (polygon[i].y < point.y and polygon[j].y >= point.y or polygon[j].y < point.y and polygon[i].y >= point.y) then
            if (polygon[i].x + ( point.y - polygon[i].y ) / (polygon[j].y - polygon[i].y) * (polygon[j].x - polygon[i].x) < point.x) then
                oddNodes = not oddNodes;
            end
        end
        j = i;
    end
    return oddNodes 
end

Components = {}
function registerComponent(comp)
    assert(comp.name, "Component needs a name")
    print("REGISTERED: " .. comp.name)
    Components[comp.name] = comp
end

function isWithinBox(mx, my, x, y, width, height)
    assert(height, "Not enough arguments")
    return mx > x and mx < x + width and my > y and my < y + height
end