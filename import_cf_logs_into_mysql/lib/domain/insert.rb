class Insert
  attr :config, :dwh

  # データーストアが何を選択されているかを保持する
  @@dwh_flag = ''

  def initialize(config, dwh)
    mysql_config = config['mysql']
    redis_config = config['redis']
    @dwh         = dwh
    if mysql_config != nil
      mysql_client = MysqlConnector.new(mysql_config)
    end

    if redis_config != nil
      redis_client = RedisConnector.new(redis_config)
    end
  end

  # DWHの選択をする
  def dwh(mode)
  end

  def insert(data)
  end

  private

  def __dwh_set
  end

  def __dwh_get_current_setting
  end

  def __dwh_remove_current_setting
  end

end
