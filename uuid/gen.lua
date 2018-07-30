math.randomseed(os.time())
local random = math.random

local function uuid4()
  local template = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
  return string.gsub(template, '[xy]', function (c)
    local v = (c == 'x') and random(0, 0xf) or random(8, 0xb)
    return string.format('%x', v)
  end)
end

for i  = 0,10 do
  uuid = uuid4()
  print(uuid)
end
