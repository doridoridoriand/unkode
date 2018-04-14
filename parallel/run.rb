require 'parallel'
require 'securerandom'
require 'optparse'
require 'time'
require 'pry'

OPTIONS = {}
OptionParser.new do |opt|
  opt.on('-n number_of_calc_times', '--number_of_calc_times', Integer) {|v| OPTIONS[:calc_times]   = v}
  opt.on('-t type_of_calc',         '--type_of_calc',         String)  {|v| OPTIONS[:type_of_calc] = v}
  opt.on('-c calcuration_method',   '--calcuration_method',   String)  {|v| OPTIONS[:calc_method]  = v}
  opt.parse!(ARGV)
end

raise OptionParser::MissingArgument, 'NoCalcurationRepeatsSpecified' unless OPTIONS[:calc_times]
raise OptionParser::MissingArgument, 'NoCalcurationTypeDetected'     unless OPTIONS[:type_of_calc]
raise OptionParser::MissingArgument, 'NoCalcurationMethodDetected'   unless OPTIONS[:calc_method]

arr = [*0..OPTIONS[:calc_times]]

if OPTIONS[:type_of_calc]    === 'thread'
  type = {in_thread: 24}
elsif OPTIONS[:type_of_calc] === 'process'
  type = {in_process: 24}
end

public

def uuid
  [SecureRandom.uuid]
end

def arr
  a = [*0..100]
  b = [101..200]
  a.map {|i|
    b.map {|j|
      i + j
    }
  }.inject(:+)
end

calc_start = Time.now

if OPTIONS[:calc_method] === 'uuid'
  resp = Parallel.map(arr, type) {|i|
    uuid
  }
else
  resp = Parallel.map(arr, type) {|i|
    arr
  }
end

calc_end = Time.now

puts "Total calc time is #{(calc_end - calc_start).round(3)} seconds."
