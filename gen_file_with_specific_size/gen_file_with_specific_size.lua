argparse = require 'argparse'
lfs      = require 'lfs'
inspect  = require 'inspect'

--[[
とりあえず参考になる文章が少なすぎるので、これを参考に実装する
http://milkpot.sakura.ne.jp/lua/lua52_manual_ja.html
--]]

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

-- try-catch もどき
 local function try_catch(what)
   local status, result = pcall(what.try)
   if not status then
     what.catch(result)
   end
   return result
 end

-- 対象のファイルの容量を調べて該当の容量に達していたらfrueを返す
local function is_enough(file_path)
end

-- 指定した保存ディレクトリのディスク残量が指定したファイルサイズ以下だった場合、例外
directory_attributes = lfs.attributes(args.directory_path)
print(inspect(directory_attributes))


-- 引数で指定したファイル名のファイルが指定したディレクトリに既に存在する場合、例外


try_catch {
  try = function()
  end,
  catch = function(error)
  end
}

--repeat
--until is_enough
