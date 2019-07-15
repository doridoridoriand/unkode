require 'pry'

public

def find_composite_num
  if self.first.divmod(self.last) == 0
    true
  else
    false
  end
end

def delete_composite(arr)
  num = arr.shift
  arr.each do |n|; if [n, num].find_composite_num; arr.delete(n); end; end
  arr.push(num)
end

def gen_prime
  arr = delete_composite((1..5000).to_a)
  delete_composite(arr).each do |n|
    delete_composite(arr)
  end
  puts delete_composite(arr).sort
end

gen_prime
