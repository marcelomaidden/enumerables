# spec/enumerable_spec.rb

require_relative '../main'

describe Enumerable do
  let(:ha) { { 'a' => 1, 'b' => 2 } }

  let(:ra) { (1..10) }

  let(:arr) { [1, 2, 3, 4] }

  let(:arr3) { %w[ant bear cat] }

  let(:arr4) { [nil, true, 99] }

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
    let(:arr2) { %w[cat dog wombat] }

    context 'Runs my_each_with_index passing a block and compare the output' do
      it { expect(arr2.my_each_with_index).to be_instance_of(Enumerator) }

      it { expect(arr2.my_each_with_index { |_item, index| _item = index * 2 }).to be_eql(arr2) }

      it { expect(ha.my_each_with_index { |_item, index| _item = index * 2 }).to be_eql(ha) }

      it { expect(ra.my_each_with_index { |_item, index| _item = index * 2 }).to be_eql(ra) }

      it { expect { arr2.my_each_with_index(3) { |item, index| puts item, index } }.to raise_error(ArgumentError) }

      it do
        expect { arr2.my_each_with_index { |item, index| puts item, index } }
          .to output("cat\n0\ndog\n1\nwombat\n2\n").to_stdout
      end

      it do
        expect { arr2.my_each_with_index { |item, index| puts item, index } }
          .not_to output("wombat\n0\ndog\n1\ncat\n2\n").to_stdout
      end
    end
  end

  describe '#my_select' do
    context 'Checks my_select method and its returns' do
      it { expect(arr.my_select).to be_instance_of(Enumerator) }

      it { expect(arr.my_select(&:even?)).to contain_exactly(2, 4) }

      it { expect(ha.my_select { |item| item == 'a' }).to be_instance_of(Hash) }

      it { expect(ra.my_select(&:even?)).to contain_exactly(2, 4, 6, 8, 10) }

      it { expect(%i[foo bar].my_select { |x| x == :foo }).to contain_exactly(:foo) }

      it { expect { arr.my_select(8) }.to raise_error(ArgumentError) }

      it { expect { arr.my_select(8, 2) }.to raise_error(ArgumentError) }

      it { expect(arr.my_select(&:even?)).not_to contain_exactly(1, 3) }
    end
  end

  describe '#my_all?' do
    context 'Checks if my_all nethod is working properly' do
      it do
        expect(arr3.my_all? { |word| word.length >= 3 })
          .to be_eql(arr3.all? { |word| word.length >= 3 })
      end

      it do
        expect(arr3.my_all? { |word| word.length >= 4 })
          .to be_eql(arr3.all? { |word| word.length >= 4 })
      end

      it { expect(arr3.my_all?(/t/)).to be_eql(arr3.all?(/t/)) }

      it { expect(arr3.my_all?(String)).to be_eql(arr3.all?(String)) }

      it { expect(arr4.my_all?).to be_eql(arr4.all?) }

      it { expect([].my_all?).to be_eql([].all?) }

      it do
        expect((1..3).my_all?(&proc { |x| x == 0 }))
          .to be_equal((1..3).all?(&proc { |x| x == 0 }))
      end
    end
  end

  describe '#my_any?' do
    context 'Checks all returns from my_any? method' do
      it do
        expect(arr3.my_any? { |word| word.length >= 3 })
          .to be_eql(arr3.any? { |word| word.length >= 3 })
      end

      it do
        expect(arr3.my_any? { |word| word.length >= 4 })
          .to be_eql(arr3.any? { |word| word.length >= 4 })
      end

      it { expect(arr3.my_any?(/t/)).to be_eql(arr3.any?(/t/)) }

      it { expect(arr3.my_any?(Integer)).to be_eql(arr3.any?(Integer)) }

      it { expect(arr4.my_any?).to be_eql(arr4.any?) }

      it { expect([].my_any?).to be_eql([].any?) }

      it do
        expect((1..3).my_any?(&proc { |x| x == 0 }))
          .to be_equal((1..3).any?(&proc { |x| x == 0 }))
      end
    end
  end

  describe '#my_none?' do
    context 'Testing my_none method' do
      it do
        expect(arr3.my_none? { |word| word.length == 5 })
          .to be_eql(arr3.none? { |word| word.length == 5 })
      end

      it do
        expect(arr3.my_none? { |word| word.length >= 4 })
          .to be_eql(arr3.none? { |word| word.length >= 4 })
      end

      it { expect(arr3.my_none?(/d/)).to be_eql(arr3.none?(/d/)) }

      it { expect(arr3.my_none?(String)).to be_eql(arr3.none?(String)) }

      it { expect([].my_none?).to be_eql([].none?) }

      it { expect([nil].my_none?).to be_eql([nil].none?) }

      it { expect([nil, false].my_none?).to be_eql([nil, false].none?) }

      it { expect([nil, false, true].my_none?).to be_eql([nil, false, true].none?) }

      it do
        expect((1..3).my_none?(&proc { |num| num.even? }))
          .to be_equal((1..3).none?(&proc { |num| num.even? }))
      end
    end
  end

  describe '#my_count' do
    context 'Checks if method my_count counts right the elements in a collection' do
      it { expect(arr.my_count).to be_equal(arr.count) }

      it { expect(arr.my_count(2)).to be_equal(arr.count(2)) }

      it { expect(arr.my_count(&:even?)).to be_equal(arr.count(&:even?)) }

      it { expect(arr3.my_count).to be_equal(arr3.count) }

      it do
        expect((1..3).my_count(&proc { |num| num.even? }))
          .to be_equal((1..3).count(&proc { |num| num.even? }))
      end
    end
  end

  describe '#my_map' do
    context 'Checks my_map method and its returns' do
      it { expect([1, 2, 3].my_map { |x| x * 2 }).to be_eql([1, 2, 3].map { |x| x * 2 }) }

      it { expect((1..4).my_map { |i| i**2 }).to be_eql((1..4).map { |i| i**2 }) }

      it { expect((1..4).my_map { 'cat' }).to be_eql((1..4).map { 'cat' }) }

      it { expect((1..3).my_map(&proc { |num| num + 1 })).to be_eql((1..3).map(&proc { |num| num + 1 })) }

      it { expect([1, 2, 3].my_map(&proc { |x| x % 2 })).to be_eql([1, 2, 3].map(&proc { |x| x % 2 })) }
    end
  end

  describe '#my_inject' do
    context 'Checks my_inject method and its return' do
      it { expect((5..10).my_inject(:+)).to be_equal((5..10).inject(:+)) }

      it do
        expect((5..10).my_inject { |sum, n| sum + n })
          .to be_equal((5..10).inject { |sum, n| sum + n })
      end

      it { expect((5..10).my_inject(1, :*)).to be_equal((5..10).inject(1, :*)) }

      it do
        expect((5..10).my_inject(2) { |product, n| product * n })
          .to be_equal((5..10).inject(2) { |product, n| product * n })
      end

      it do
        expect(%w[cat sheep bear biggest].my_inject do |memo, word|
          memo.length > word.length ? memo : word
        end)
          .to be_eql(%w[cat sheep bear biggest].inject do |memo, word|
                       memo.length > word.length ? memo : word
                     end)
      end
    end
  end
end
