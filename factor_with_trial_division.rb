
n = ARGV.first.to_i

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
