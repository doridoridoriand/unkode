require 'securerandom'
require 'objspace'
require 'logger'
require 'optparse'
require 'pry'

logger = Logger.new STDOUT
big_string = []

logger.info('Container Start')
logger.info("#{(ObjectSpace.memsize_of_all * 0.001 * 0.001).floor(3)} MB")

(0..10).to_a.map {|r|
  big_string << (0..2000000).to_a.map {|r| SecureRandom.uuid}.join
  logger.info("#{(ObjectSpace.memsize_of_all * 0.001 * 0.001).floor(3)} MB")
}
