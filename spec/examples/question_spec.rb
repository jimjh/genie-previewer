# ~*~ encoding: utf-8 ~*~
require 'spec_helper'

describe 'Question' do

  context 'given JSON markup' do

    def parse(text); Aladdin::Render::Question.parse text; end

    it 'should raise a ParseError on invalid JSON' do
      text = '{xxx}'
      expect { parse text }.to raise_error(Aladdin::Render::ParseError)
      text = '[[?]]'
      expect { parse text }.to raise_error(Aladdin::Render::ParseError)
      text = '[["?"]]'
      expect { parse text }.to raise_error(Aladdin::Render::ParseError)
    end

    it 'should raise a ParseError on invalid format' do
      text = '{"format": "mcq"}'
      expect { parse text}.to_not raise_error
      text = '{"format": "MCQ"}'
      expect { parse text }.to_not raise_error
      text = '{"format": "Mcq"}'
      expect { parse text }.to_not raise_error
      text = '{"format": "w"}'
      expect { parse text }.to raise_error(Aladdin::Render::ParseError)
    end

    it 'should return a question object' do
      text = '{"format": "short"}'
      parse(text).should be_kind_of(Aladdin::Render::Question)
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