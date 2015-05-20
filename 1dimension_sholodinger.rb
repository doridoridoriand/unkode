# 一次元のシュレディンガー方程式を解く
class Calc1Dim
  def target_formula(x)
    return x
  end

  def calc_euler(n, initial_x, initial_y, last_x)
    x = initial_x
    y = initial_y
    h = (last_x.to_i - initial_x.to_i) / n
    puts h.round(100)

    for i in 0..n do
      x = initial_x + i * h
      y += target_formula(x) * h
      #puts "X=#{x.round(100)}, Y=#{y.round(100)}"
    end
    y
  end

  def main_func
    calc_euler(1024, 0, 0, 5)
  end
end
c1d = Calc1Dim.new
c1d.main_func
