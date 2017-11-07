require 'fileutils'
require 'logger'
require 'pry'

logger = Logger.new('image.file.diff.log')

DIR_NAME = '/Volumes/LACIE_1TB/Adobe'
$dir = []

public

def absolute_filepath
  if self.include?(DIR_NAME)
    return self
  else
    return "#{DIR_NAME}/#{self}"
  end
end

def directories
  # 不要なディレクトリを削除
  self.delete('.')  if self.include?('.')
  self.delete('..') if self.include?('..')

  self.map {|entry|
    $dir << entry.absolute_filepath if File.directory?(entry.absolute_filepath)
  }
  #binding.pry
  $dir.map {|d|
    binding.pry
    Dir.entries(d).directories
  }
end

base = Dir.entries(DIR_NAME)
base.directories

