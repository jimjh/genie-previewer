# ~*~ encoding: utf-8 ~*~
require 'spec_helper'

describe 'Weak Comparator' do

  context 'given a comparator host' do

    let(:comparator) { Aladdin::Support::WeakComparator }

    def random_string
      (0...50).map{ ('a'..'z').to_a[rand(26)] }.join
    end

    it 'should accept simple strings that are exactly the same' do
      str = random_string
      comparator.same?(str, str.clone).should be_true
    end

    it 'should reject simple strings that are different' do
      comparator.same?(random_string, random_string).should be_false
    end

    it 'should accept simple integers that are the same' do
      n = Random.rand(10000000)
      comparator.same?(n.to_s, n).should be_true
    end

    it 'should reject simple integers that are different' do
      n1, n2 = Random.rand(1000000), Random.rand(1000000)
      comparator.same?(n1.to_s, n2).should be_false
    end

    it 'should accept simple floats that are the same' do
      n = Random.rand
      comparator.same?(n.to_s, n).should be_true
    end

    it 'should reject simple floats that are different' do
      comparator.same?(Random.rand.to_s, Random.rand).should be_false
    end

    it 'should accept numbers that are numerically equivalent' do
      comparator.same?('42.0000', 42).should be_true
      comparator.same?('42e0', 42).should be_true
      comparator.same?('42', 42).should be_true
      comparator.same?('42.0000', 42.0).should be_true
      comparator.same?('42e0', 42.0).should be_true
      comparator.same?('42', 42.0).should be_true
    end

    it 'should reject non-numeric submissions for numeric answers' do
      comparator.same?('x', 42.0).should be_false
      comparator.same?('true', 42.0).should be_false
      comparator.same?('{', 42.0).should be_false
      comparator.same?([42], 42.0).should be_false
    end

    it 'should accept booleans that are the same' do
      comparator.same?('true', true).should be_true
      comparator.same?('T', true).should be_true
      comparator.same?('false', false).should be_true
      comparator.same?('F', false).should be_true
    end

    it 'should reject booleans that are different' do
      comparator.same?('false', true).should be_false
      comparator.same?('F', true).should be_false
      comparator.same?('true', false).should be_false
      comparator.same?('T', false).should be_false
    end

    it 'should accept hashes that are the same' do
      comparator
        .same?({'X' => 'a', 'Y' => '42', 'Z' => 't'},
               {'X' => 'a', 'Y' =>  42.0, 'Z' => true})
        .should eql('X' => true, 'Y' => true, 'Z' => true)
    end

    it 'should reject hashes that have different sizes' do
      comparator
        .same?({'X' => 'a', 'Y' => 'b'},
              {X: 'a', Y: 'b', Z: 'c'})
        .should be_false
    end

    it 'should reject hashes that have different elements' do
      comparator
        .same?({'X' => 'a', 'Y' => '42', 'Z' => 't'},
               {'X' => 'a', 'Y' =>  16,  'Z' =>  true})
        .should eql('X' => true, 'Y' => false, 'Z' => true)
    end

  end

end


