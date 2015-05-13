require 'benchmark'

TIMES = 100000000

target_hash = {}

puts Benchmark.measure {
  for i in 0..TIMES do
    target_hash[i.to_s] = i.to_s
  end
}

target_array = []

puts Benchmark.measure {
  for i in 0..TIMES do
    target_array << i.to_s
  end
}
