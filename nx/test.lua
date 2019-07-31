local Test = {}

local componentTests = {}

function Test.run(name, testFunction)
    if DEBUG then
        assert(name)
        assert(type(name) == "string")
        assert(testFunction, "no test function supplied for " .. name)
        assert(
            type(testFunction) == "function",
            "testFunction is of type " .. type(testFunction) .. " expected function"
        )

        Test.currentSuiteName = name
        testFunction()
        print(name .. " tests completed successfully")
    end
end

function Test.registerComponentTest(componentClass, testFunction)
    if DEBUG then
        assert(componentClass.name)
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
    if type(actual) == "boolean" then
        actual = booleanToString(actual)
    end

    if type(expected) == "boolean" then
        expected = booleanToString(expected)
    end

    assert(expected == actual, message .. "\nexpected: " .. expected .. "\nactual:" .. actual)
end

return Test
