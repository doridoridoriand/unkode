$: << File.expand_path(File.join(['.']))
require 'app'

# 3072~4096リクエスト受け付けたらkillする
# use Unicorn::WorkerKiller::MaxRequests, 3072, 4096

run Cuba
