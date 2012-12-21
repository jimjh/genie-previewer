# ~*~ encoding: utf-8 ~*~
require 'spec_helper'

describe 'Table' do

  include_context 'parser'

  let(:obj) do
    { format: 'table',
      question: 'fill me in',
      grid: [%w(1 ? 3), %w(? 5 6)],
      answer: [%w(0 2 0), %w(4 0 0)]
    }
  end

  context 'given valid problem' do

    it 'should render a table' do
      p = parse(obj.to_json)
      p.should be_kind_of(Aladdin::Render::Table)
      p.should be_valid
      p.render(index: 0).should match %r{<table}
    end

    it 'should encode the answer' do
      p = parse(obj.to_json)
      p.should be_kind_of(Aladdin::Render::Table)
      p.should be_valid
      p.answer.should eq('0' => {'1' => '2'}, '1' => {'0' => '4'})
    end

  end

  context 'given invalid problem' do

    it 'should raise a RenderError if the grid is missing' do
      h = obj
      h.delete(:grid)
      p = parse(h.to_json)
      p.should_not be_valid
      expect { p.render(index: 0) }.to raise_error(Aladdin::Render::RenderError)
      expect { p.save! }.to raise_error(Aladdin::Render::RenderError)
    end

    it 'should raise a RenderError if the grid is malformed' do
      h = obj
      h[:grid] = %w(1 2 3 4 5 6)
      p = parse(h.to_json)
      p.should_not be_valid
      expect { p.render(index: 0) }.to raise_error(Aladdin::Render::RenderError)
    end

    it 'should raise a RenderError if the answer is malformed' do
      h = obj
      h[:answer] = [%w(1 2 3)]
      p = parse(h.to_json)
      p.should_not be_valid
      expect { p.render(index: 0) }.to raise_error(Aladdin::Render::RenderError)
    end

  end

end
