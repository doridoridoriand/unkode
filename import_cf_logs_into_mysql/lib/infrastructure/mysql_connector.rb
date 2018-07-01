class MysqlConnector
  attr :configure, :schema
  # コネクションを張る
  # 当該のスキーマがあるか確認する
  def initialize(configure, schema)
    @configure = configure
    @schema    = schema
  end
end

