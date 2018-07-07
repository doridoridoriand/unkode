class RedisConnector
  attr :configure

  # Redisとちゃんと接続できるかチェックする
  def initialize(configure)
    @configure = configure
  end
end
