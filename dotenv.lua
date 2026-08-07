--[[
dotenv.lua

Copyright (c) 2026 Syrup Studios

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
]]

--[[
For people that don't read the README
INLINE COMMENTS DONT WORK
DO NOT ATTEMPT

THIS IS GOOD
# Port
PORT=8080

THIS IS BAD
PORT=8080 # Port
]]


local dotenv = {}
local values = {}


local function parseFile(path)
    local file = io.open(path, "r")
    if not file then
        return nil, "could not open " .. path
    end

    local result = {}
    for line in file:lines() do
        line = line:gsub("^%s+", ""):gsub("%s+$", "")
        if line ~= "" and not line:match("^#") then
            local key, value = line:match("^([%w_]+)%s*=%s*(.*)$")
            if key then
                value = value:gsub('^"(.*)"$', "%1"):gsub("^'(.*)'$", "%1")
                result[key] = value
            end
        end
    end
    file:close()
    return result
end

function dotenv.load(path)
    path = path or ".env"
    local parsed, err = parseFile(path)
    if not parsed then
        return false, err
    end
    dotenv.values = parsed
    return true
end

function dotenv.get(key, default)
    return dotenv.values[key] or os.getenv(key) or default
end

function dotenv.check(examplePath, envPath)
    examplePath = examplePath or ".env.example"
    envPath = envPath or ".env"

    local example, exampleErr = parseFile(examplePath)
    if not example then
        return true
    end

    local envFile = io.open(envPath, "r")
    if not envFile then
        print("Warning: " .. envPath .. " not found. Copy " .. examplePath .. " to " .. envPath .. " and fill in your values.")
        return false, { missingFile = true }
    end
    envFile:close()

    local missing = {}
    for key in pairs(example) do
        if dotenv.values[key] == nil and os.getenv(key) == nil then
            table.insert(missing, key)
        end
    end

    if #missing > 0 then
        table.sort(missing)
        print("Warning: " .. envPath .. " is missing " .. #missing .. " key(s) present in " .. examplePath .. ":")
        for _, key in ipairs(missing) do
            print("  - " .. key)
        end
        return false, { missingKeys = missing }
    end

    return true
end

return dotenv
