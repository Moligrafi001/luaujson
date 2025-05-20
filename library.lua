local luaujson = {}

-- Settings
local Settings = {
  DebugMode = false
}

-- Local Functions
local function AdmMsg(type, msg)
  if type == 1 then
    print("[ luaujson ] - " .. tostring(msg))
  elseif type == 2 then
    warn("[ luaujson ] - " .. tostring(msg))
  elseif type == 3 then
    error("[ luaujson ] - " .. tostring(msg))
  elseif type == 9 then
    if msg == 1 then
      print(".*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.")
    elseif msg == 2 then
      warn(".*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.")
    elseif msg == 3 then
      error(".*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.")
    end
  end
end
local function d()
  if Settings.DebugMode then
    return true
  end
  return false
end
local function ManualParse(body)
  local pos = 1
  
  local function skipWhitespace()
    while body:sub(pos, pos):match("%s") do
      pos = pos + 1
    end
  end
  
  local function parseValue()
    skipWhitespace()
    local char = body:sub(pos, pos)
    
    if char == '"' then
      return parseString()
    elseif char == '{' then
      return parseObject()
    elseif char == '[' then
      return parseArray()
    elseif body:sub(pos, pos + 3) == "true" then
      pos = pos + 4
      return true
    elseif body:sub(pos, pos + 4) == "false" then
      pos = pos + 5
      return false
    elseif body:sub(pos, pos + 3) == "null" then
      pos = pos + 4
      return nil
    else
      return parseNumber()
    end
  end
  
  local function parseString()
    pos = pos + 1
    local start = pos
    while body:sub(pos, pos) ~= '"' do
      pos = pos + 1
    end
    local str = body:sub(start, pos - 1)
    pos = pos + 1
    return str
  end
  
  local function parseNumber()
    local start = pos
    while body:sub(pos, pos):match("[0-9+-.eE]") do
      pos = pos + 1
    end
    local num = tonumber(body:sub(start, pos - 1))
    return num
  end
  
  local function parseArray()
    local result = {}
    pos = pos + 1 -- skip [
    skipWhitespace()
    if body:sub(pos, pos) == "]" then
      pos = pos + 1
      return result
    end
    while true do
      table.insert(result, parseValue())
      skipWhitespace()
      if body:sub(pos, pos) == "]" then
        pos = pos + 1
        break
      end
      pos = pos + 1
    end
    return result
  end

  local function parseObject()
    local result = {}
    pos = pos + 1
    skipWhitespace()
    if body:sub(pos, pos) == "}" then
      pos = pos + 1
      return result
    end
    while true do
      local key = parseString()
      skipWhitespace()
      pos = pos + 1
      local value = parseValue()
      result[key] = value
      skipWhitespace()
      if body:sub(pos, pos) == "}" then
        pos = pos + 1
        break
      end
      pos = pos + 1
    end
    return result
  end

  return parseValue()
end

-- Public Functions
function luaujson:Start()
  if d() then
    AdmMsg(9, 1)
    AdmMsg(1, "Library started successfully")
    AdmMsg(9, 1)
  end
end
function luaujson:Parse(req, res)
  if req.Url then
    req = request(req)
    if req.Success then
      if game:GetService("HttpService"):JSONDecode(req.Body)[res] then
        return game:GetService("HttpService"):JSONDecode(req.Body)[res]
      else
        return ManualDecode(req.Body)
      end
    else
      AdmMsg(3, "Request failed: " .. req.Url or "NO URL" .. " | " .. req.StatusCode or "NO CODE")
    end
  else
    AdmMsg(3, "Parse function missing URL param")
  end
end

-- Export Library
return luaujson