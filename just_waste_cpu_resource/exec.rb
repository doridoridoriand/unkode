require 'bigdecimal'
require 'optparse'

OPTIONS = {
  repeatable: false
}
OptionParser.new do |opt|
  opt.on('-r', '--repeatable') {|v| OPTIONS[:repeatable] = v}
  opt.parse!
end

public

def calc_pi
  num_of_repeats = 10

  a = BigDecimal(1)
  b = BigDecimal(1) / BigDecimal(2).sqrt(2)
  t = BigDecimal(1) / 4
  p = BigDecimal(1)

  for i in 1..num_of_repeats do
    an = (a + b) / 2
    b = (a * b).sqrt(2)
    t -= p * (an - a) * (an - a)
    p *= 2
    a = an
  end

  puts ((a + b) * (a + b) / (4 * t)).to_s[0, 2 ** num_of_repeats]
end

calc_pi

while OPTIONS[:repeatable] do
  calc_pi
end
