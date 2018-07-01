module Validator

  def mysql_directive_exists?
    raise StandardError, 'MySQLDirectiveNotExistError' unless self['mysql']
  end

end
