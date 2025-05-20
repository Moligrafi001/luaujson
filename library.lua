local luaujson = {}

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

-- Public Functions
function luaujson:Start()
  AdmMsg(9, 1)
  AdmMsg(1, "Library started successfully")
  AdmMsg(9, 1)
end
function luaujson:Parse(req, res)
  if req.Url then
    req = request(req)
    if req.Sucess then
     if game:GetService("HttpService"):JSONDecode(req.Body)[res] then
      return game:GetService("HttpService"):JSONDecode(req.Body)[res]
     end
    else
    end
  else
    AdmMsg(3, "Parse function missing URL param")
  end
end

-- Export Library
return luaujson