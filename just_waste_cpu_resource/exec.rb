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

accuracy = 10

a = BigDecimal(1)
b = BigDecimal(1) / BigDecimal(2).sqrt(2)
t = BigDecimal(1) / 4
p = BigDecimal(1)

for i in 1..accuracy do
  an = (a + b) / 2
  b = (a * b).sqrt(2)
  t -= p * (an - a) * (an - a)
  p *= 2
  a = an
end

puts ((a + b) * (a + b) / (4 * t)).round(2 ** accuracy)
