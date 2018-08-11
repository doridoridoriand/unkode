local argparse = require 'argparse'
local lfs      = require 'lfs'
local inspect  = require 'inspect'

math.randomseed(os.time())
local random = math.random

local parser = argparse(
  "gen_file_with_specific_size.lua",
  "指定した容量(GB)のファイルを作成するスクリプト"
)

parser:option(
  "-s --size",
  "File Size(GB)"
)
parser:option(
  "-d --directory-path",
  "Absolute Directory Path of output file."
)
parser:option(
  "-f --filename",
  "Fileame"
)
local args = parser:parse()

print(inspect(args))
print(inspect(args.directory_path))

-- UUID4もどき
local function uuid()
  local template = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
  return string.gsub(template, '[xy]', function (c)
    local v = (c == 'x') and random(0, 0xf) or random(8, 0xb)
    return string.format('%x', v)
  end
  )
end
