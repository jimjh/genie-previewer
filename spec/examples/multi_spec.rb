# ~*~ encoding: utf-8 ~*~
require 'spec_helper'

# I am not sure if testing markup is a good idea. Nonetheless, I need a way to
# make sure that the rendering works. So I am just going to test for the
# minimum here.
describe 'Multi' do

  include_context 'parser'

  context 'given valid question' do

    it 'should render an MCQ form' do
      text = <<-eos
        {
          "format": "multi",
          "question": "How tall is Mt. Everest?",
          "answer": "A",
          "options": {
            "A": "452 inches",
            "B": "8.85 kilometers"
          }
        }
      eos
      q = parse(text)
      q.should be_kind_of(Aladdin::Render::Multi)
      q.should be_valid
      html = q.render(index: 0)
      html.should match %r{<form}
      html.should match %r{How tall is Mt\. Everest\?}
      html.should match %r{452 inches}
      html.should match %r{8\.85 kilometers}
    end

  end

  context 'given invalid question' do

    it 'should raise a RenderError if options is missing' do
      text = <<-eos
        {
          "format": "multi",
          "question": "How tall is Mt. Everest?",
          "answer": "A"
        }
      eos
      q = parse(text)
      q.should_not be_valid
      expect { q.render(index: 0) }.to raise_error(Aladdin::Render::RenderError)
    end

    it 'should raise a RenderError if options is not a hash' do
      text = <<-eos
        {
          "format": "multi",
          "question": "How tall is Mt. Everest?",
          "answer": "A",
          "options": ["A"]
        }
      eos
      q = parse(text)
      q.should_not be_valid
      expect { q.render(index: 0) }.to raise_error(Aladdin::Render::RenderError)
    end

    it 'should raise a RenderError if question is not a string' do
      text = <<-eos
        {
          "format": "multi",
          "question": [],
          "answer": "A",
          "options": {"A": "B"}
        }
      eos
      q = parse(text)
      q.should_not be_valid
      expect { q.render(index: 0) }.to raise_error(Aladdin::Render::RenderError)
    end

    it 'should raise a RenderError if answer is not a string' do
      text = <<-eos
        {
          "format": "multi",
          "question": "How tall is Mt. Everest?",
          "answer": {},
          "options": {"A": "B"}
        }
      eos
      q = parse(text)
      q.should_not be_valid
      expect { q.render(index: 0) }.to raise_error(Aladdin::Render::RenderError)
    end
  end

end
