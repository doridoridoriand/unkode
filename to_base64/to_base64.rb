require 'pry'
public

def string_to_binary
  self.hex.to_s(2)
end

def to_6_bits
  self.scan(/.{1, #{6}}/)
end

binding.pry

p ARGV.first.string_to_binary.to_6_bits
