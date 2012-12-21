# ~*~ encoding: utf-8 ~*~
require 'spec_helper'

describe 'Problem' do

  include_context 'parser'

  context 'given JSON markup' do

    it 'should raise a ParseError on invalid JSON' do
      text = '{xxx}'
      expect { parse text }.to raise_error(Aladdin::Render::ParseError)
      text = '[[?]]'
      expect { parse text }.to raise_error(Aladdin::Render::ParseError)
      text = '[["?"]]'
      expect { parse text }.to raise_error(Aladdin::Render::ParseError)
    end

    it 'should raise a ParseError on invalid format' do
      text = '{"format": "short"}'
      expect { parse text }.to_not raise_error
      text = '{"format": "Short"}'
      expect { parse text }.to_not raise_error
      text = '{"format": "SHORT"}'
      expect { parse text }.to_not raise_error
      text = '{"format": "w"}'
      expect { parse text }.to raise_error(Aladdin::Render::ParseError)
    end

    it 'should raise a ParseError on missing formats' do
      text = '{"question": "x", "answer": "y"}'
      expect { parse text }.to raise_error(Aladdin::Render::ParseError)
    end

    it 'should not accept missing questions' do
      text = '{"format": "multi", "answer": "y"}'
      parse(text).should_not be_valid
    end

    it 'should not accept questions that are not strings' do
      text = '{"format": "multi", "question": ["x"], "answer": "y"}'
      parse(text).should_not be_valid
    end

    it 'should not accept missing answers' do
      text = '{"format": "multi", "question": "x"}'
      parse(text).should_not be_valid
    end

    it 'should accept complete questions' do
      text = '{"format": "short", "question": "x", "answer": "y"}'
      parse(text).should be_valid
    end

    it 'should return a problem object' do
      text = '{"format": "short"}'
      parse(text).should be_kind_of(Aladdin::Render::Problem)
    end

    it 'should generate an ID if one is not given' do
      text = '{"format": "short"}'
      question = parse(text)
      question.id.should_not be_nil
      question.id.should_not be_empty
      text = '{"format": "short", "id": "x"}'
      question = parse(text)
      question.id.should eq('x')
    end

  end

end
