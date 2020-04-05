local Test = {}

local componentTests = {}

function Test.run(name, testFunction)
    if ALLOW_DEBUG then
        assert(name)
        assert(type(name) == "string", "Name is " .. type(name) .. " expected string")
        assert(testFunction, "no test function supplied for " .. name)
        assert(
            type(testFunction) == "function",
            "testFunction is of type " .. type(testFunction) .. " expected function"
        )

        Test.currentSuiteName = name
        testFunction()
        print(name .. " tests completed successfully")
        collectgarbage("collect")
    end
end

function Test.registerComponentTest(componentClass, testFunction)
    if ALLOW_DEBUG then
        assert(componentClass.name, "Component has no name")
        componentTests[componentClass.name] = testFunction
    end
end

function Test.runComponentTests()
    for i, componentName in ipairs(getKeys(componentTests)) do
        Test.run(componentName .. " Component", componentTests[componentName])
    end
end

function Test.assert(expected, actual, message)
    assert(message, "no description supplied for test case")
    message = Test.currentSuiteName .. ": " .. message

    -- Assert equal types
    Test.assertEqualValues(
        Test.getType(expected),
        Test.getType(actual),
        message .. "\n" .. "Types of expected and actual are not comparable"
    )

    if not Test.isTable(expected) then
        Test.assertEqualValues(expected, actual, message)
        return
    end

    if Test.isNxObject(expected) then
        Test.assertEqualValues(expected, actual, message)
        return
    end

    if Test.isList(expected) then
        Test.assertEqualLists(expected, actual, message)
        return
    end
end

-- TODO: I'd like assertEqualValues and assertEqualLists to return a bool and a message rather than fire an assert
-- This way we can a red/green test these asserts to make sure they actually work
function Test.assertEqualValues(expected, actual, message)
    assert(message, "no message provided")

    local expectedString = tostring(expected)
    local actualString = tostring(actual)

    if Test.isNxObject(expected) then
        expectedString = expected:toString()
        actualString = actual:toString()
    end

    local failureMessage = message .. "\nexpected: " .. expectedString .. "\nactual: " .. actualString

    if Test.isFloatingPoint(expected) and Test.isFloatingPoint(actual) then
        local epsilon = 0.00000000000001
        assert(math.abs(expected - actual) < epsilon, failureMessage)
    else
        assert(expected == actual, failureMessage)
    end
end

function Test.assertEqualLists(expected, actual, message)
    Test.assertEqualValues(#expected, #actual, message .. " (List length)")

    for i, exp in ipairs(expected) do
        local act = actual[i]
        Test.assert(exp, act, message .. " (index " .. i .. ")")
    end
end

function Test.isNxObject(data)
    if Test.isTable(data) then
        return data.type ~= nil
    else
        return false
    end
end

function Test.isTable(tb)
    return type(tb) == "table"
end

function Test.isList(tb)
    return Test.isTable(tb) and #tb > 0
end

function Test.getType(thing)
    if Test.isNxObject(data) then
        return "nxObject"
    end

    if Test.isTable(thing) then
        return "table"
    end

    if Test.isList(thing) then
        return "list"
    end

    return type(thing)
end

function Test.isFloatingPoint(num)
    if type(num) == "number" then
        local int, frac = math.modf(num)
        if frac ~= 0 then
            return true
        end
    end
    return false
end

-- Test the test framework. Someone has to watch the watchmen
Test.run(
    "Test",
    function()
        local Object = {}
        function Object.new()
            local object = newObject(Object)
            return object
        end
        local object = Object.new()

        Test.assert(true, Test.isTable({}), "{} is a table")
        Test.assert(true, Test.isList({1, 2, 3}), "{1,2,3} is a list")
        Test.assert(true, Test.isNxObject(Object.new()), "Object is an NxObject")

        Test.assert(false, Test.isTable(5), "number is not a table")
        Test.assert(false, Test.isList(5), "number is not a list")
        Test.assert(false, Test.isList({hello = 5, world = 10}), "arbitrary table is not a list")
        Test.assert(false, Test.isNxObject({}), "{} is not an NxObject")
        Test.assert(false, Test.isFloatingPoint(5), "Integer is not a floating point")
        Test.assert(true, Test.isFloatingPoint(5.3), "Floating point is a floating point")

        Test.assertEqualLists({}, {}, "Empty lists are equal lists")

        Test.assertEqualLists({{1, 3}, {2}}, {{1, 3}, {2}}, "Nested lists are equal lists")

        Test.assertEqualValues(0.3, 0.2 + 0.1, "Test fuzzy floating points")
    end
)

return Test
