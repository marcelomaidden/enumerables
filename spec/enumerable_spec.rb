# spec/enumerable_spec.rb

require_relative '../main'

describe Enumerable do
  describe '#my_each' do
    let(:arr) { [1, 2, 3] }

    let(:ha) { { 'a' => 1, 'b' => 2 } }

    let(:ra) { (1..10) }

    context 'Runs my_each towards and enum' do
      it { expect(arr.my_each).to be_instance_of(Enumerator) }

      it { expect(ha.my_each).to be_instance_of(Enumerator) }

      it { expect(arr.my_each).not_to be_instance_of(Integer) }

      it { expect(arr.my_each { |n| puts n * 2 }).to be_eql([1, 2, 3]) }

      it { expect(ha.my_each { |n| puts n * 2 }).to be_eql({ 'a' => 1, 'b' => 2 }) }

      it { expect(ra.my_each { |n| puts n * 2 }).to be_eql((1..10)) }

      it { expect { arr.my_each(2) { |n| puts n * 2 } }.to raise_error(ArgumentError) }

      it { expect(arr.my_each { |n| puts n * 2 }).not_to be_eql([2, 4, 6]) }

      it { expect { arr.my_each { |n| puts n * 2 } }.to output("2\n4\n6\n").to_stdout }

      it { expect { arr.my_each { |n| puts n * 2 } }.not_to output("1\n2\n3\n").to_stdout }

      it { expect { |b| arr.my_each(&b) }.to yield_control }

      it { expect { |b| arr.my_each(&b) }.not_to yield_successive_args }
    end
  end
end
