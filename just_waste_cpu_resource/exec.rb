require 'pry'
require 'parallel'
require 'bigdecimal'
require 'optparse'

OPTIONS = {}
OptionParser.new do |opt|
  opt.on('-c core', 'Number of Cores', Integer) {|v| OPTIONS[:cores] = v}
  opt.on('-r repeatable', '--repeatable')       {|v| OPTIONS[:repeatable] = v}
  opt.parse!
end

num_of_repeats = 10
accuracy       = 1000

a = BigDecimal(1)
b = BigDecimal(1) / BigDecimal(2).sqrt(accuracy)
t = BigDecimal(1) / 4
p = BigDecimal(1)

for i in 1..num_of_repeats do
  an = (a + b) / 2
  b = (a * b).sqrt(accuracy)
  t -= p * (an - a) * (an - a)
  p *= 2
  a = an
end

puts ((a + b) * (a + b) / (4 * t)).round(2 ** num_of_repeats)
