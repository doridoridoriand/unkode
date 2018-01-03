require 'pry'
#e.g. https://tech.mktime.com/entry/183

# Only running on terminal with 256bit color support.
(1..255).to_a.map {|n| puts "\e[38;5;#{n}mああああああああああああああああああああああああああああああああああああああああああああ\e[0m"; sleep(0.5)}

# Running with terminal only supports 8 and 16bit color.
(1..8).to_a.map {|set|
  ((31..37).to_a << 39 << (90..97).to_a).flatten.map {|txt|
    ((40..47).to_a << 49 << (100..107).to_a).flatten.map {|bg|
      puts "\e[#{set};#{txt};#{bg}mああああああああああああああああああああああああああああああああああああああああああああ\e[0m"
      sleep(0.5)
    }
  }
}
