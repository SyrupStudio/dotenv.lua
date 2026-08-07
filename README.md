# dotenv.lua
A minimal dotenv library for Lua 5.1+

**Usage example in main.lua**
**If you need help join our [Discord](https://discord.gg/KJJsva8Krx)**

## How to install

### From [LDE](https://lde.sh/)
1. Run 
```bash
lde add dotenv
```

2. Require it

```lua
require("dotenv")
```



### From source
1. Drop `dotenv.lua` into your project and require it

```lua
require("dotenv")
```


## How it works (lazy edition)
```lua
local dotenv = require("dotenv")

local ok, err = dotenv.load()
if not ok then
    error(err)
end

-- if you are lazy you can just do
-- dotenv.load()

dotenv.check()

local apiKey = dotenv.get("API_KEY")
local port = dotenv.get("PORT", "8080") -- fallback to 8080
```

### .env File Format
```env
# comments are ignored ofc
API_KEY=abc123
PORT=8080
```

## Limitations
INLINE COMMENTS **ARE NOT SUPPORTED**
Why you may ask? Becuase the parser treats everything after the `=` as the value
```env
# comments are ignored ofc
API_KEY=abc123
PORT=8080 # DO NOT DO THIS
```

Ofc unless you want a lovely error like this
```text
attempt to perform arithmetic on local 'b' (a string value)
```

