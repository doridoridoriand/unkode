require 'benchmark'

TIMES = 100000
REPEATS = 3

def measure_hash
  target_hash = {}
  puts Benchmark.measure {
    for i in 1..TIMES do
      target_hash[i.to_s] = i.to_s
    end
  }
end

def measure_array
  target_array = []
  puts Benchmark.measure {
    for i in 1..TIMES do
      target_array << i.to_s
    end
  }
end

for i in 1..REPEATS do
  puts "measure_hash start. REPEATS: #{i}"
  measure_hash
  puts "==="
  puts "measure_array start. REPEATS: #{i}"
  measure_array
  puts "==="
end
