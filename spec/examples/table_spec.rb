# ~*~ encoding: utf-8 ~*~
require 'spec_helper'

describe 'Table' do

  include_context 'parser'

  context 'given valid question' do

    it 'should render a table' do
      text = <<-eos
        {
          "format": "table",
          "question": [["1", "?", "3"], ["?", "5", "6"]],
          "answer": [[0, "2", 0], ["4", 0, 0]]
        }
      eos
      q = parse(text)
      q.should be_kind_of(Aladdin::Render::Table)
      q.should be_valid
      html = q.render
      html.should match %r{<table}
    end

  end

  context 'given invalid question' do

    it 'should raise a RenderError if the question is malformed' do
      text = <<-eos
        {
          "format": "table",
          "question": ["1", "?", "3", "?", "5", "6"],
          "answer": [[0, "2", 0], ["4", 0, 0]]
        }
      eos
      q = parse(text)
      q.should_not be_valid
      expect { q.render }.to raise_error(Aladdin::Render::RenderError)
    end

    it 'should raise a RenderError if the answer is malformed' do
      text = <<-eos
        {
          "format": "table",
          "question": [["1", "?", "3"], ["?", "5", "6"]],
          "answer": [[0, "2", 0]]
        }
      eos
      q = parse(text)
      q.should_not be_valid
      expect { q.render }.to raise_error(Aladdin::Render::RenderError)
    end

  end

end
