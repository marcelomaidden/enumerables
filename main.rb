module Enumerable
  def my_each
    return to_enum(:my_each) unless block_given?

    count = 0
    while count < to_a.length
      yield to_a[count]
      count += 1
    end
  end

  def my_each_with_index
    return to_enum(:my_each_with_index) unless block_given?

    count = 0
    while count < to_a.length
      yield(to_a[count], count)
      count += 1
    end
  end

  def my_select
    return to_enum(:my_select) unless block_given?

    n_array = []
    to_a.my_each do |i| n_array << i if yield(item) end
    n_array
  end
end
