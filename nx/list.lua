local List = {}

function List.new(type)
    local self = newObject(List)
    self.isTyped = type ~= nil
    self.elementType = type

    self.innerList = {}
    self.listLength = 0
    return self
end

--- API

function List:clone()
    local newList = List.new(self.elementType)
    for i, v in self:each() do
        newList:add(v)
    end

    return newList
end

function List:length()
    return self.listLength
end

function List:at(index)
    assert(type(index) == "number", "List:at() takes a number")
    self:assertInBounds(index)
    return self.innerList[index]
end

function List:each()
    return ipairs(self.innerList)
end

-- this is o(n), :(
function List:eachReversed()
    local reversedList = copyReversed(self.innerList)
    return ipairs(reversedList)
end

function List:add(...)
    local params = {...}
    for i, object in ipairs(params) do
        assert(object, "Cannot add a nil to a list")
        if self.isTyped then
            assert(object:type() == self.elementType, "added object is wrong type")
        end

        self.listLength = self.listLength + 1
        self.innerList[self.listLength] = object
    end
end

function List:removeAt(index)
    self:assertInBounds(index)

    local deleted = self.innerList[index]

    for i = index, #self.innerList do
        self.innerList[i] = self.innerList[i + 1]
    end

    self.listLength = self.listLength - 1

    return deleted
end

-- This is o(n), jesus christ
function List:enqueue(element)
    assert(element, "element cannot be nil")
    local newInnerList = {element}
    for i, v in self:each() do
        newInnerList[i + 1] = v
    end
    self.innerList = newInnerList
end

function List:pop()
    return self:removeAt(self.listLength)
end

function List:clear()
    self.innerList = {}
    self.listLength = 0
end

function List:indexOf(element)
    assert(element, "element cannot be nil")
    for i, item in self:each() do
        if item == element then
            return i
        end
    end
    return nil
end

function List:deleteElement(element)
    assert(element, "element cannot be nil")
    local index = self:indexOf(element)

    if index then
        return self:removeAt(index)
    end

    return nil
end

function List:shuffle()
    for i = self.listLength, 1, -1 do
        local rand = love.math.random(i)
        self.innerList[i], self.innerList[rand] = self.innerList[rand], self.innerList[i]
    end
end

function List:getRandomElement()
    return self.innerList[love.math.random(self.listLength)]
end

--- !! Dangerous stuff !!

function List:copyInner()
    return copyList(self.innerList)
end

function List:rawInner()
    return self.innerList
end

-- Private

function List:assertInBounds(index)
    assert(
        index > 0 and index <= self.listLength,
        "Index out of bounds, attempted to access index " .. index .. " where length is " .. self.listLength
    )
end

--- Test

local Test = require("nx/test")
Test.run(
    "List",
    function()
        local subject = List.new()
        Test.assert(0, subject:length(), "Empty list has length 0")

        subject:add(2, 4, 8)
        Test.assert(2, subject:at(1), "First index is first element added to list")
        Test.assert(3, subject:length(), "List length is accurate after adding several elements")
        Test.assert(8, subject:at(3), "Last index is last element added to list")

        subject:removeAt(1)
        Test.assert(4, subject:at(1), "Content shifts over when removing from first position")

        -- CLEAR AND REBUILD TESTS
        subject:clear()
        Test.assert(0, subject:length(), "Content is emptied on clear")
        subject:add(5, 10, 15, 20, 25, 30, 35)
        Test.assert(15, subject:removeAt(3), "Removing an element returns that element")
        Test.assert(20, subject:at(3), "Elements shift over when removed at arbitrary point")

        -- INDEX OF
        Test.assert(5, subject:indexOf(30), "IndexOf returns a real index for something in the list")
        Test.assert(nil, subject:indexOf(31), "IndexOf returns nil for something not in the list")
        Test.assert(35, subject:pop(), "Pop returns last element")

        -- DELETE ELEMENT
        Test.assert(10, subject:deleteElement(10), "Deleting an element returns that element")
        Test.assert(nil, subject:indexOf(10), "Deleting an element causes it to no longer exist in the list")

        -- CLONE TESTS
        local clone = subject:clone()
        Test.assert(4, clone:length(), "Clone has same length as original")
        Test.assert(subject:at(3), clone:at(3), "Clone and original have the same value at a given index")
        subject:removeAt(3)
        clone:removeAt(2)
        Test.assert(30, subject:at(3), "Removing an element from the original modifies the original but not the clone")
        Test.assert(30, clone:at(3), "Removing an element from the clone modifies the clone but not the original")
        Test.assert(25, clone:at(2), "Clone's elements are disperate from the original")
        Test.assert(20, subject:at(2), "Subject's elements are disperate from the clone")
    end
)

return List
