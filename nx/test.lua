local Test = {}

function Test.register(name, fn)
    if DEBUG then
        assert(name)
        assert(type(name) == "string")
        assert(fn)
        assert(type(fn) == "function")

        Test.currentSuiteName = name
        fn()
        print(name .. " tests completed successfully")
    end
end

function Test.assert(expected, actual, message)
    assert(message, "no description supplied for test case")
    message = Test.currentSuiteName .. ': ' .. message
    if type(actual) == "boolean" then
        actual = booleanToString(actual)
    end
    
    if type(expected) == "boolean" then
        expected = booleanToString(expected)
    end

    assert(expected == actual, message .. "\nexpected: " .. expected .. "\nactual:" .. actual)
end

return Test
