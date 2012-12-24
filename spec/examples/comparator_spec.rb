# ~*~ encoding: utf-8 ~*~
require 'spec_helper'

class Dummy
  include Aladdin::Mixin::WeakComparator
end

describe 'Weak Comparator' do

  context 'given a dummy host' do

    let(:dummy) { Dummy.new }

    def random_string
      (0...50).map{ ('a'..'z').to_a[rand(26)] }.join
    end

    it 'should accept simple strings that are exactly the same' do
      str = random_string
      dummy.same?(str, str.clone).should be_true
    end

    it 'should reject simple strings that are different' do
      dummy.same?(random_string, random_string).should be_false
    end

    it 'should accept simple integers that are the same' do
      n = Random.rand(10000000)
      dummy.same?(n.to_s, n).should be_true
    end

    it 'should reject simple integers that are different' do
      n1, n2 = Random.rand(1000000), Random.rand(1000000)
      dummy.same?(n1.to_s, n2).should be_false
    end

    it 'should accept simple floats that are the same' do
      n = Random.rand
      dummy.same?(n.to_s, n).should be_true
    end

    it 'should reject simple floats that are different' do
      dummy.same?(Random.rand.to_s, Random.rand).should be_false
    end

    it 'should accept numbers that are numerically equivalent' do
      dummy.same?('42.0000', 42).should be_true
      dummy.same?('42', 42.0).should be_true
    end

    it 'should reject non-numeric submissions for numeric answers' do
      dummy.same?('x', 42.0).should be_false
      dummy.same?('true', 42.0).should be_false
      dummy.same?('{', 42.0).should be_false
      dummy.same?([42], 42.0).should be_false
    end

    it 'should accept booleans that are the same' do
      dummy.same?('true', true).should be_true
      dummy.same?('T', true).should be_true
      dummy.same?('false', false).should be_true
      dummy.same?('F', false).should be_true
    end

    it 'should reject booleans that are different' do
      dummy.same?('false', true).should be_false
      dummy.same?('F', true).should be_false
      dummy.same?('true', false).should be_false
      dummy.same?('T', false).should be_false
    end

    it 'should accept enumerables that are the same' do
      dummy.same?(%w(1 2 3.0), [1.0, 2.0, 3.0]).should be_true
    end

    it 'should reject enumerables that have different sizes' do
      dummy.same?(%w(a b c), %w(x y)).should be_false
      dummy.same?(%w(b c), %w(x y z)).should be_false
    end

    it 'should reject enumerables that have different elements' do
      dummy.same?(%w(a b c), %w(a b x)).should be_false
    end

  end

end


