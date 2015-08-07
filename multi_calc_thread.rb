require 'benchmark'

CALC_TIMES = 100000000

a = []; b = []; c = []
result = []
threads = []

cpu = (0..7).to_a
#puts Benchmark.measure {
  cpu.each do |core|
    threads << Thread.fork(core) do |unko|
      for i in 0..CALC_TIMES do
        a[i] = i * 0.5
        b[i] = 2
        c[i] = i * 2.8
      end

      for i in 0..CALC_TIMES do
        result[i] = a[i] + b[i] - c[i]
      end
    end
  end

  threads.each do |thread|
    thread.join
  end
#}
