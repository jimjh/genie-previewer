# ~*~ encoding: utf-8 ~*~
require 'spec_helper'

describe 'Short' do

  include_context 'parser'

  context 'given valid question' do

    it 'should render a short answer form' do
      text = <<-eos
        {
          "format": "short",
          "question": "How tall is Mt. Everest?",
          "answer": "A"
        }
      eos
      q = parse(text)
      q.should be_kind_of(Aladdin::Render::Short)
      q.should be_valid
      html = q.render
      html.should match %r{<form}
      html.should match %r{How tall is Mt\. Everest\?}
    end

  end

  context 'given invalid question' do

    it 'should raise a RenderError if question is not a string' do
      text = <<-eos
        {
          "format": "short",
          "question": ["How tall is Mt. Everest?"],
          "answer": "A"
        }
      eos
      q = parse(text)
      q.should_not be_valid
      expect { q.render }.to raise_error(Aladdin::Render::RenderError)
    end

  end

end
