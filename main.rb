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
    to_a.my_each do |i| n_array << i if yield(i) end
    n_array
  end

  def my_all?(value = nil)
    if block_given?
      to_a.my_each do |i| return false if yield(i) == false end
      return true
    elsif value.nil?
      to_a.my_each do |i| return false if i.nil? || i == false end
    else
      to_a.my_each do |i| return false if i != value end
    end
    true
  end

  def my_any?(param = nil)
    if block_given?
      to_a.my_each do |i| return false if yield(i) == false && i.nil? end
      return true
    elsif 
      to_a.my_each do |i| return false if i == false end
      return true
    elsif
      to_a.my_each do |i| return true if i.class == param end
    else 
        to_a.my_each do |i| return true if i == param end
    end
    false
  end

  def my_none?(value = nil, &block)
    !to_a.my_any?(value, &block)
  end

  def my_count?(value = nil)
    count = 0
    if block_given?
      to_a.my_each do |i| count += 1 if yield(i) end
    elsif value.nil?
      count = to_a.length
    else
      count = to_a.my_select do |i| i == value end.length
    end
    count
  end

  def my_map(value = nil)
    return to_enum(:my_map) unless block_given? || !value.nil?

    array = []
    if value.nil?
      to_a.each do |i| array << yield(i) end
    else
      to_a.each do |i| array << value.call(i) end
    end
    array
  end

  def my_inject(start=nil, smbl=nil)
    if(start.is_a?(Symbol) || start.is_a?(String)) && smbl.nil?
      smbl = start
      start = nil
    end
    if !smbl.nil && !block_given?
      to_a.my_each do |i| start = start.nil? ? i : start.send(smbl, i) end
    else
      to_a.my_each do |i| start = start.nil? ? i : yield(start, i) end
    end
    start
  end
end


puts "my_any test"

puts %w[ant bear cat].my_any? { |word| word.length >= 3 } #=> true
puts %w[ant bear cat].my_any? { |word| word.length >= 4 } #=> true
puts %w[ant bear cat].my_any?(/d/)                        #=> false
puts [nil, true, 99].my_any?(Integer)                     #=> true
puts [nil, true, 99].my_any?                              #=> true
puts [].my_any?                                           #=> false

puts "my_none test"

puts %w[ant bear cat].my_none? { |word| word.length >= 3 } #=> false
puts %w[ant bear cat].my_none? { |word| word.length >= 4 } #=> false
puts %w[ant bear cat].my_none?(/d/)                        #=> true
puts [nil, true, 99].my_none?(Integer)                     #=> false
puts [nil, true, 99].my_none?                              #=> false
puts [].my_none?                                           #=> true

puts "my_count?"

puts %w[ant bear cat].my_count?
puts %w[ant bear cat].my_count?("bear")
puts %w[ant bear cat cat].my_count? { |n| n == "cat" }

puts "my_map"

puts [2, 3, 6].my_map { |n| n * 2 }

puts "my_inject"

# Sum some numbers
(5..10).my_inject(:+)                             #=> 45
# Same using a block and inject
(5..10).my_inject { |sum, n| sum + n }            #=> 45
# Multiply some numbers
(5..10).my_inject(1, :*)                          #=> 151200
# Same using a block
puts (5..10).my_inject(1) { |product, n| product * n }