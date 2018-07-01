module Validator

  # mysqlディレクティブが存在するか否かをチェックする
  # @return boolean
  def mysql_directive_exists?
    raise StandardError, 'MySQLDirectiveNotExistError' unless self['mysql']
    true
  end

  # redisディレクティブが存在するか否かをチェックする
  # @return boolean
  def redis_directive_exists?
    raise StandardError, 'RedisDirectiveNotExistError' unless self['redis']
    true
  end

end
