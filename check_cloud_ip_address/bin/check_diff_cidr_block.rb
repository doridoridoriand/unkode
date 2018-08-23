require 'bundler'
Bundler.require

####
#
# クラウドベンダーの提供するIPアドレスに変更がないか調べるスクリプト
# 定期的にファイルを関しして、列挙されているCIDRブロックに変化が内科を調べる
# ファイルに記載されているCIDRブロックの順序は変わる可能性が全然あるので、
# あくまでもCIDRブロックが変化していないかについてをチェックする
#
####
ip_range_source = YAML.load_file(File.join(__dir__, '..', 'config', 'ip_range.yml'))
db_config       = YAML.load_file(File.join(__dir__, '..', 'config', 'database.yml'))

public

# ローカルファイルのdiffをチェックする方式は除外する
ip_range_source = ip_range_source.first['address_range_list'].map {|r|
  r unless r.values.flatten.first['gettype'] == 'local'
}.compact

# 以前のファイルの存在を確認。なかった保存して終了する


binding.pry
