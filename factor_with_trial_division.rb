
abort "Usage: ruby factor_with_trial_division.rb <positive_integer>" if ARGV.empty?

begin
  n = Integer(ARGV.first)
  abort "Input must be a positive integer" if n <= 0
rescue ArgumentError
  abort "Error: Invalid integer input"
end

a = []
while n.div(2) == 0
  a << [2]
  n = n / 2
end

f = 3
while f * f <= n
  if n.div(f) == 0
    a << [f]
    n = n / f
  else
    f = f + 2
  end
end

if n != 1
  a << [n]
end

p a
