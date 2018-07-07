class MysqlConnector
  attr :configure
  # コネクションを張る(ちゃんとコネクションを張れるかチェックする)
  def initialize(configure)
    @configure = configure
  end
end

