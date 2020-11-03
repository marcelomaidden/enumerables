# spec/enumerable_spec.rb

require_relative '../main.rb'

describe Enumerable do
  subject { arr = [1, 2, 3]}

  context 'Runs my_each towards and enum' do
    it { expect(subject.my_each).to be_instance_of(Enumerator)}  
    it { expect(subject.my_each { |n| puts n * 2}).to be_eql([1, 2, 3])}  
  end
end