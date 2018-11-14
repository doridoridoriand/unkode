require 'childprocess'
require 'pry'

process = ChildProcess.build("ruby", "-e", "sleep")

process.start
process.alive?
process.stop
