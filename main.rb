# rubocop:disable Metrics/MethodLength
# rubocop:disable Metrics/CyclomaticComplexity
# rubocop:disable Metrics/PerceivedComplexity
# rubocop:disable Metrics/ModuleLength

module Enumerable
  def my_each
    return to_enum(:my_each) unless block_given?

    count = 0
    while count < to_a.length
      yield to_a[count]
      count += 1
    end
    self
  end

  def my_each_with_index
    return to_enum(:my_each_with_index) unless block_given?

    count = 0
    while count < to_a.length
      yield(to_a[count], count)
      count += 1
    end
    self
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
      to_a.my_each { |i| return false unless i.is_a? value }
    elsif !value.nil? && value.instance_of?(Regexp)
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
      to_a.my_each { |i| return true if i.is_a? param }
    elsif param.instance_of?(Regexp)
      to_a.my_each { |i| return true unless param.match(i).nil? }
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
                  @result = yield(@result, storage)
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

# rubocop:enable Metrics/MethodLength
# rubocop:enable Metrics/CyclomaticComplexity
# rubocop:enable Metrics/PerceivedComplexity
# rubocop:enable Metrics/ModuleLength
