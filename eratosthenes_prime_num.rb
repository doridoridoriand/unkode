class PrimeNum
@@max_num = 5000

  def gen_number_array
    array = []
    for i in 1..@@max_num do
      array << i
    end
    array.shift
    array
  end

  def find_multiple_number(common_num, target_num)
    if common_num.divmod(target_num)[1] == 0
      true
    else
      false
    end
  end

  def delete_multiple(array)
    target_num = array.shift
    array.each do |node|
      if find_multiple_number(node, target_num)
        array.delete(node)
      end
    end
    array.push(target_num)
  end

  # ひたすら合成数を探している
  def gen_prime
    array = delete_multiple(gen_number_array)
    delete_multiple(array).each do |node|
      delete_multiple(array)
    end
    puts delete_multiple(array).sort
  end
end

pm = PrimeNum.new
pm.gen_prime
