class Insert
  attr :config, :dwh
 
  def initialize(config, dwh)
    mysql_config = config['mysql']
    redis_config = config['redis']
    @dwh         = dwh
    if mysql_config != nil
      @mysql_client = MysqlConnector.new(@mysql_config, schema)
    end

    if redis_config != nil
      @mysql_client = RedisConnector.new(@mysql_config, schema)
    end
  end

  # DWHの選択をする
  def dwh
    binding.pry
  end

end
