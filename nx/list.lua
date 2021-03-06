local List = {}

local local_ipairs = ipairs

function List.new(elementType)
    local self = newObject(List)
    if elementType then
        assert(type(elementType) == "table", "List.new(elementType) expects table for elementType")
    end

    self.isTyped = elementType ~= nil
    self.elementType = elementType

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

function List:cloneReversed()
    local newList = List.new(self.elementType)
    for i = self.listLength, 1, -1 do
        newList:add(self:at(i))
    end

    return newList
end

function List:length()
    return self.listLength
end

function List:at(index)
    assert(type(index) == "number", "List:at() takes a number, got " .. type(index))
    self:assertInBounds(index)
    return self.innerList[index]
end

function List:setAt(index, value)
    assert(type(index) == "number", "List:at() takes a number, got " .. type(index))
    self:assertInBounds(index)
    self.innerList[index] = value
end

function List:each()
    return local_ipairs(self.innerList)
end

function List:__tostring()
    return "List [" .. self:length() .. "] " .. string.join(self.innerList, ", ")
end

function List.__eq(left, right)
    if left:length() == right:length() then
        for i, v in left:each() do
            if left.innerList[i] ~= right.innerList[i] then
                return false
            end
        end

        return true
    end

    return false
end

-- this is o(n), :(
function List:eachReversed()
    local reversedList = copyReversed(self.innerList)
    return local_ipairs(reversedList)
end

function List:add(...)
    local params = {...}
    local local_assert = assert
    for i, object in local_ipairs(params) do
        local_assert(object, "Cannot add a nil to a list")
        if self.isTyped then
            local_assert(type(object) == "table", "Expected a table, got a " .. type(object))
            local_assert(object:type() == self.elementType, "added object is wrong type")
        end

        self.listLength = self.listLength + 1
        self.innerList[self.listLength] = object
    end
    return self
end

function List:removeAt(index)
    if self:length() == 0 then
        return nil
    end
    self:assertInBounds(index)
    self.listLength = self.listLength - 1
    return table.remove(self.innerList, index)
end

function List:insert(index, value)
    self.listLength = self.listLength + 1
    return table.insert(self.innerList, index, value)
end

function List:enqueue(value)
    assert(value, "element cannot be nil")
    self:insert(1, value)
end

function List:unpack()
    return unpack(self.innerList)
end

function List:pop()
    return self:removeAt(self.listLength)
end

function List:peek()
    if self.listLength == 0 then
        return nil
    end

    return self:at(self.listLength)
end

function List:sort(sortingfn)
    table.sort(self.innerList, sortingfn)
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

function List:removeElement(element)
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
        Test.assert(10, subject:removeElement(10), "Deleting an element returns that element")
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

        -- REVERSE CLONE TEST
        subject = List.new()
        subject:add(1, 2, 3, 4, 5)
        local reversedClone = subject:cloneReversed()
        Test.assert(5, reversedClone:at(1), "Reversed list's first element is original list's last element")
        Test.assert(1, reversedClone:at(5), "Reversed list's last element is original list's first element")

        -- INSERT TESTS
        subject = List.new()
        subject:add(1, 4)
        subject:insert(2, 2)
        subject:insert(3, 3)
        Test.assert({1, 2, 3, 4}, subject:rawInner(), "Insert")

        -- ENQUEUE TEST
        subject = List.new()
        subject:enqueue(1)
        subject:enqueue(2)
        subject:enqueue(3)
        Test.assert(3, subject:at(1), "Enqueue first element")
        Test.assert(2, subject:at(2), "Enqueue second element")
        Test.assert(1, subject:at(3), "Enqueue last element")

        -- PEEK TESTS
        subject = List.new()
        Test.assert(nil, subject:peek(), "Peeking an empty list is nil")
        subject:add(1, 7, 9, 11)
        Test.assert(11, subject:peek(), "Peeking gets the last item")

        -- REMOVE LAST THING TEST
        subject = List.new()
        subject:add(1, 2)
        Test.assert(1, subject:removeAt(1), "Remove first thing")
        Test.assert(2, subject:removeAt(1), "Remove second thing")
        Test.assert(nil, subject:removeAt(1), "Attempt to remove when there's nothing left")

        -- TEST EQ OPERATOR
        local leftList = List.new()
        local rightList = List.new()
        Test.assert(true, leftList == rightList, "Empty lists are equal")
        leftList:add(1, 2, 3, 4)
        rightList:add(1, 2, 3, 4)
        Test.assert(true, leftList == rightList, "Lists with same contents are equal")
        rightList:add(5)
        Test.assert(true, leftList ~= rightList, "Lists with different sizes are not equal")
        leftList:add(5)
        leftList:setAt(3, 20)
        Test.assert(true, leftList ~= rightList, "Lists with different contents are not equal")
    end
)

return List
