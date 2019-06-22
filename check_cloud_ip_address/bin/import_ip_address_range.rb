require 'bundler'
Bundler.require

ip_range_source = YAML.load_file(File.join(__dir__, '..', 'config', 'ip_range.yml'))
db_config       = YAML.load_file(File.join(__dir__, '..', 'config', 'database.yml'))

redis = Redis.new(host: db_config.first['redis']['host'],
                  port: db_config.first['redis']['port'],
                  db:   db_config.first['redis']['db'])

@logger = Logger.new STDOUT
@logger.level = Logger::INFO

public

def aws(vendor_information)
  file = open(vendor_information.values.flatten.first['uri']).read
  res = JSON.parse(file)['prefixes']
  cidrs = res.map {|r| r['ip_prefix']}
  @logger.info("Number of IPaddresses: #{cidrs.ip_lists.count}")
  cidrs.ip_lists
end

def azure(vendor_information)
  file = open(vendor_information.values.flatten.first['uri'].split('//').last).read
  xml_source = REXML::Document.new(file)
  res = xml_source.elements.each('/AzurePublicIpAddresses/Region/IpRange') do |elem|
    elem
  end
  cidrs = res.map {|r| r['Subnet']}
  @logger.info("Number of IPaddresses: #{cidrs.ip_lists.count}")
  cidrs.ip_lists
end

def gcp(vendor_information)
  pid, res = systemu "dig -t txt #{vendor_information['gcp'].first['uri']} +short"
  netblocks_txt = res.split(' ').map {|r|
    r if r.include?('include')
  }.compact.map {|r|
    r.split(':').last
  }
  cidrs = netblocks_txt.map {|r|
    pid, res = systemu "dig -t txt #{r} +short"
    res.split(' ').map {|r|
      r if r.include?('ip4')
    }.compact
  }.flatten.map {|r| r.split(':').last}
  @logger.info("Number of IPaddresses: #{cidrs.ip_lists.count}")
  cidrs.ip_lists
end

def ip_lists
  ips = Parallel.map(self.map {|r| IPAddress r}) do |cidr|
    cidr.map {|ip| ip.octets.join('.')}
  end
  ips.flatten
end

vendor_ips = ip_range_source.first['address_range_list'].map {|vendor|
  @logger.info("Start to parse #{vendor.keys.first}")
  {vendor.keys.first.to_sym => send(vendor.keys.first, vendor)}
}

vendor_ips.map {|r|
  r.values.flatten.map {|ip|
    @logger.info("IPAddress: #{ip}, Vendor: #{r.keys.first.to_s}")
    redis.set(ip, r.keys.first.to_s)
  }
}
