module Enumerable
  def my_each
    return to_enum(:my_each) unless block_given?

    count = 0
    while count < to_a.length
      yield to_a[count]
      count += 1
    end
  end
end
