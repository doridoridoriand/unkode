-- いい感じのMySQLコネクタが無いので一旦コメントアウト
-- local mysql = require('resty.mysql')
math.randomseed(os.time())
local random = math.random

-- 多分これだと衝突する気がする
local function uuid4()
  local template = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
  return string.gsub(template, '[xy]', function (c)
    local v = (c == 'x') and random(0, 0xf) or random(8, 0xb)
    return string.format('%x', v)
  end)
end

repeat
  uuid = uuid4()
  print(uuid)
until 1 == 0
