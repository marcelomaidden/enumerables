# spec/enumerable_spec.rb

require_relative '../main'

describe Enumerable do

  let(:ha) { { 'a' => 1, 'b' => 2 } }

  let(:ra) { (1..10) }

  let(:arr) { [1, 2, 3, 4] }

  describe '#my_each' do

    context 'Runs my_each towards and enum' do

      it { expect(arr.my_each).to be_instance_of(Enumerator) }

      it { expect(ha.my_each).to be_instance_of(Enumerator) }

      it { expect(arr.my_each).not_to be_instance_of(Integer) }

      it { expect(arr.my_each { |n| puts n * 2 }).to be_eql([1, 2, 3, 4]) }

      it { expect(ha.my_each { |n| puts n * 2 }).to be_eql({ 'a' => 1, 'b' => 2 }) }

      it { expect(ra.my_each { |n| puts n * 2 }).to be_eql((1..10)) }

      it { expect { arr.my_each(2) { |n| puts n * 2 } }.to raise_error(ArgumentError) }

      it { expect(arr.my_each { |n| puts n * 2 }).not_to be_eql([2, 4, 6, 8]) }

      it { expect { arr.my_each { |n| puts n * 2 } }.to output("2\n4\n6\n8\n").to_stdout }

      it { expect { arr.my_each { |n| puts n * 2 } }.not_to output("1\n2\n3\n").to_stdout }

      it { expect { |b| arr.my_each(&b) }.to yield_control }

      it { expect { |b| arr.my_each(&b) }.not_to yield_successive_args }

    end
  end

  describe '#my_each_with_index' do

    let(:arr2) { %w(cat dog wombat)}
    
    context 'Runs my_each_with_index passing a block and compare the output' do

      it { expect(arr2.my_each_with_index).to be_instance_of(Enumerator)}

      it { expect(arr2.my_each_with_index { |item, index|  item = index * 2 }).to be_eql(arr2)}

      it { expect(ha.my_each_with_index {|item, index| item = index * 2 }).to be_eql(ha) }

      it { expect(ra.my_each_with_index {|item, index| item = index * 2  }).to be_eql(ra)}

      it { expect{arr2.my_each_with_index(3){|item, index| puts item, index }}.to raise_error(ArgumentError)}

      it { expect { arr2.my_each_with_index { |item, index| puts item, index } }.to output("cat\n0\ndog\n1\nwombat\n2\n").to_stdout }

      it { expect { arr2.my_each_with_index { |item, index| puts item, index } }.not_to output("wombat\n0\ndog\n1\ncat\n2\n").to_stdout }

    end
  end

  describe '#my_select' do
    context 'Checks my_select method and its returns' do

      it { expect(arr.my_select).to be_instance_of(Enumerator)}

      it { expect(arr.my_select {|num| num.even? }).to contain_exactly(2, 4)}

      it { expect(ra.my_select {|num| num.even? }).to contain_exactly(2, 4, 6, 8, 10)}

      it { expect([:foo, :bar].my_select { |x| x == :foo }).to contain_exactly(:foo) }

      it { expect { arr.my_select(8)}.to raise_error(ArgumentError)}

      it { expect { arr.my_select(8, 2)}.to raise_error(ArgumentError)}

      it { expect(arr.my_select {|num| num.even? }).not_to contain_exactly(1, 3)}

    end    
  end
end 
