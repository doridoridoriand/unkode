require 'parallel'
require 'securerandom'
require 'pry'

uuids = Parallel.map([*0..1000000], in_threads: 12) {|i|
  [SecureRandom.uuid, i]
}

binding.pry

uuids.count
