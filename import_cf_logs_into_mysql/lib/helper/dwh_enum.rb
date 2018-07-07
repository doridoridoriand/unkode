module DwhEnum
  MYSQL      = 1
  MEMSQL     = 2
  CLICKHOUSE = 3
  REDIS      = 4

  DWH_NAME = {
    DwhEnum::MYSQL      => 'MySQL',
    DwhEnum::MEMSQL     => 'MemSQL',
    DwhEnum::CLICKHOUSE => 'ClickHouse',
    DwhEnum::REDIS      => 'Redis'
  }

  def self.all
    self.constants.map {|name| self.const_get(name)}
  end
end
