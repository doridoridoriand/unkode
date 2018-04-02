require 'parallel'
require 'securerandom'
require 'optparse'
require 'pry'

OPTIONS = {}
OptionParser.new do |opt|
  opt.on('-n number_of_calc_times', '--number_of_calc_times', Integer) {|v| OPTIONS[:calc_times]   = v}
  opt.on('-t type_of_calc',         '--type_of_calc',         String)  {|v| OPTIONS[:type_of_calc] = v}
  opt.parse!(ARGV)
end

raise OptionParser::MissigArgument, 'NoCalcurationRepeatsSpecified' unless OPTIONS[:calc_times]
raise OptionParser::MissigArgument, 'NoCalcurationTypeDetected'     unless OPTIONS[:type_of_calc]

arr = [*0..OPTIONS[:calc_times]]

if OPTIONS[:type_of_calc]    === 'thread'
  type = {in_thread: 24}
elsif OPTIONS[:type_of_calc] === 'process'
  type = {in_process: 24}
end

uuids = Parallel.map(arr, type) {|i|
  [SecureRandom.uuid, i]
}

