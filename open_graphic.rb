require 'curses'
require 'rmagick'
require 'optparse'

Cruses.init_screen
columns = Curses.cols / 2
Curses.close_screen

OPTIONS = {}
OptionParser.new do |opt|
  opt.on('-f filename', '--filename', String) {|v| OPTIONS[:filename] = v}
  opt.parse(ARGV)
end

source = Magick::Image.read(OPTIONS[:filename]).first
image = source.sample(1.0 * columns / source.columns)

puts (0...image.rows).map {|row|
  image.get_pixels(0, row, image.columns, 1).map {|pixel|
    color = [pixel.red, pixel.green, pixel.blue].map {|n| n * 5 / (255 * 255)}
    "\x1b[48;5;#{16 + color[0] * 36 + color[1] * 6 + color[2]}m  \x1b[0m"
  }.join
}.join("\n!")
