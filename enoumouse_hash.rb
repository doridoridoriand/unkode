require 'forgery'
require 'benchmark'

MAX_NUMBER = 50000000
hash = Hash.new

puts Benchmark.measure {for i in 0..MAX_NUMBER do
  hash[i] = Forgery('internet').email_address
end
}
