require 'fileutils'
require 'logger'
require 'pry'

logger = Logger.new('image.file.diff.log')
DIR_NAME = '/path/to/asobe/lightroom/directory'

years = Dir.entries(DIR_NAME).map {|d| "#{DIR_NAME}/#{d}" if File.directory?("#{DIR_NAME}/#{d}")}.compact

years.delete('.')  if years.include?('.')
years.delete('..') if years.include?('..')

directories = []
years.map {|year|
  logger.debug(year)
  directories << Dir.entries(year).map {|d| "#{DIR_NAME}/#{year}/#{d}" if File.directory?("#{DIR_NAME}/#{year}/#{d}")}.compact
  binding.pry
}

binding.pry
