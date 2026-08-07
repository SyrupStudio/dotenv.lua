-- main.lua
-- THIS IS A EXAMPLE FILE AND A MINIMAL ONE

local dotenv = require("dotenv") -- loads the library
local ok, err = dotenv.load()
if not ok then
    error(err)
end
dotenv.check() -- checks the file

local a = dotenv.get("a") -- looks for "a" in the .env file and uses taht as the variable
local b = dotenv.get("b") -- looks for "b" in the .env file and uses that as the variable

print(a + b) -- prints the sum of a and b
