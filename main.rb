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
end


puts "my_any test"

puts %w[ant bear cat].my_any? { |word| word.length >= 3 }
puts %w[ant bear cat].my_any? { |word| word.length >= 4 }
puts %w[ant bear cat].my_any?(/d/)                        #=> false
puts [nil, true, 99].my_any?(Integer)                     #=> true
puts [nil, true, 99].my_any?                              #=> true
puts [].my_any?