# rubocop:disable Metrics/MethodLength
# rubocop:disable Metrics/CyclomaticComplexity
# rubocop:disable Metrics/PerceivedComplexity

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
    to_a.my_each { |i| n_array << i if yield(i) }
    n_array
  end

  def my_all?(value = nil)
    if block_given?
      to_a.my_each { |i| return false if yield(i) == false }
      return true
    elsif value.nil?
      to_a.my_each { |i| return false if i.nil? || i == false }
    elsif !value.nil? && (value.is_a? Class)
      to_a.my_each { |i| return false unless [i.class, i.class.superclass].include?(value) }
    elsif !value.nil? && value.class == Regexp
      to_a.my_each { |i| return false unless value.match(i) }
    else
      to_a.my_each { |i| return false if i != value }
    end
    true
  end

  def my_any?(param = nil)
    if block_given?
      to_a.my_each { |i| return true if yield(i) }
      return false
    elsif param.nil?
      to_a.my_each { |i| return true if i }
    elsif param.is_a? Class
      to_a.my_each { |i| return true if [i.class, i.class.superclass].include? (param) }
    elsif param.class == Regexp
      to_a.my_each { |i| return true if i == param.march(i) }
    else
      to_a.my_each { |i| return true if i == param }
    end
    false
  end

  def my_none?(value = nil, &block)
    !to_a.my_any?(value, &block)
  end

  def my_count(value = nil)
    count = 0
    if block_given?
      to_a.my_each { |i| count += 1 if yield(i) }
    elsif value.nil?
      count = to_a.length
    else
      count = to_a.my_select { |i| i == value }.length
    end
    count
  end

  def my_map(proc = nil)
    return to_enum(:my_map) unless block_given? || !proc.nil?

    array = []
    if proc.nil?
      to_a.each { |i| array.push(yield(i)) }
    else
      to_a.each { |i| array.push(proc.call(i)) }
    end
    array
  end

  def my_inject(param1 = nil, param2 = nil)
    # only call my_inject without parameters and block
    to_a.my_each do |storage|
      @result = if block_given? && !param1.nil? && param2.nil?
                  if @result.nil?
                    yield(param1, storage)
                  else
                    @result = yield(@result, storage)
                  end
                elsif !block_given? && !param1.nil? && !param2.nil?
                  if @result.nil?
                    param1.send(param2, storage)
                  else
                    @result.send(param2, storage)
                  end
                elsif @result.nil?
                  storage
                elsif !block_given? && param1.nil? && param2.nil?
                  @result += storage
                elsif !block_given? && param2.nil?
                  @result.send(param1, storage)
                else
                  @result = yield(@result, storage)
                end
    end
    @result
  end
end

def multiply_els(array)
  array.my_inject(:*)
end

true_array = [1, 0, 8, 4, 6, 8, 7, 2, 1, 7, 4, 0, 3, 0, 5, 2, 1, 2, 0, 0, 8, 8, 3, 3, 1, 0, 5, 7, 7, 7, 2, 1, 0, 4, 4, 7, 2, 5, 2, 6, 4, 0, 2, 7, 7, 2, 2, 8, 8, 6, 2, 4, 0, 6, 8, 0, 8, 7, 2, 0, 4, 8, 2, 1, 3, 3, 2, 0, 8, 3, 5, 1, 8, 7, 4, 7, 6, 4, 6, 6, 3, 8, 3, 5, 1, 0, 5, 8, 8, 0, 5, 4, 5, 5, 4, 5, 0, 1, 4, 2]
puts true_array.my_any?(Numeric)

# rubocop:enable Metrics/MethodLength
# rubocop:enable Metrics/CyclomaticComplexity
# rubocop:enable Metrics/PerceivedComplexity
