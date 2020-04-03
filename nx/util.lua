function newObject(obj_t)
    object = {}

    -- Do some lua magic so that myActor:update() calls Actor.update(myActor)
    setmetatable(object, obj_t)
    obj_t.__index = obj_t

    -- Call actor:type to get Actor class.
    function object:type()
        return obj_t
    end

    if not object.toString then
        function object:toString()
            return "<object does not implement toString()>"
        end
    end

    return object
end

-- math
function sign(n)
    if n > 0 then
        return 1
    end

    if n < 0 then
        return -1
    end

    return 0
end

function clamp(num, low, high)
    if num < low then
        return low, true, false
    end

    if num > high then
        return high, false, true
    end

    return num, false, false
end

function degreeToRadian(degree)
    return degree * math.pi / 180
end

function radianToDegree(radian)
    return radian * 180 / math.pi
end

function angleCompare(angle1, angle2)
    assert(angle1)
    assert(angle2)
    local delta = math.abs(angle2 - angle1) % (math.pi * 2)
    if delta > math.pi then
        return math.pi * 2 - delta
    else
        return delta
    end
end

-- Generic list utilities
function append(table, element)
    table[#table + 1] = element
    return element
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
    for i = #list, 1, -1 do
        copy[sz] = list[i]
        sz = sz + 1
    end
    return copy
end

function deleteAt(table, index)
    local deleted = table[index]
    for i = index, #table do
        table[i] = table[i + 1]
    end
    return deleted
end

function deleteFromList(table, element)
    local index = indexOf(table, element)
    if index then
        return deleteAt(table, index)
    end
    return nil
end

function indexOf(table, element)
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

function swap(table, index1, index2)
    local e1 = table[index1]
    table[index1] = table[index2]
    table[index2] = e1
end

-- TODO: get index of maximum, also does this function do what it claims?
function getIndexOfMinimum(list)
    local index = 1
    for i = 2, #list do
        if not list[index] or list[i] and math.abs(list[index]) > math.abs(list[i]) then
            index = i
        end
    end

    return index
end

function getRandom(list)
    return list[love.math.random(#list)]
end

-- string utilities
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
    joiner = joiner or ""
    assert(type(joiner) == "string")

    local result = ""
    local len = #table
    for i, v in ipairs(table) do
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

function booleanToString(b)
    if b then
        return "true"
    else
        return "false"
    end
end

-- From stackoverflow
-- https://stackoverflow.com/questions/31730923/check-if-point-lies-in-polygon-lua
function insidePolygon(polygon, point)
    local oddNodes = false
    local j = #polygon
    for i = 1, #polygon do
        if (polygon[i].y < point.y and polygon[j].y >= point.y or polygon[j].y < point.y and polygon[i].y >= point.y) then
            if
                (polygon[i].x + (point.y - polygon[i].y) / (polygon[j].y - polygon[i].y) * (polygon[j].x - polygon[i].x) <
                    point.x)
             then
                oddNodes = not oddNodes
            end
        end
        j = i
    end
    return oddNodes
end
