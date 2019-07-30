local Test = {}

function Test.register(name, fn)
    if DEBUG then
        assert(name)
        assert(type(name) == "string")
        assert(fn)
        assert(type(fn) == "function")

        fn()
        print(name .. " tests completed successfully")
    end
end

function Test.assert(expected, actual, message)
    assert(message, "no description supplied for test case")
    assert(expected, message .. "\nfailed to supply expected (first arg)")
    assert(actual, message .. "\nactual is nil")

    assert(expected == actual, message .. "\nexpected: " .. expected .. "\nactual:" .. actual)
end

return Test
