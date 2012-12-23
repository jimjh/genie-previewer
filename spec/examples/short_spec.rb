# ~*~ encoding: utf-8 ~*~
require 'spec_helper'

describe 'Short' do

  include_context 'parser'

  let(:obj) do
    { format: 'short',
      question: 'How tall is Mt. Everest?',
      answer: 'A'
    }
  end

  context 'given valid problem' do

    it 'should render a short answer form' do
      q = parse(obj.to_json)
      q.should be_kind_of(Aladdin::Render::Short)
      q.should be_valid
      html = q.render(index: 0)
      html.should match %r{<form}
      html.should match %r{How tall is Mt\. Everest\?}
    end

    it 'should allow numeric answers' do
      h = obj
      h[:answer] = 5.67
      q = parse(h.to_json)
      q.should be_valid
      html = q.render(index: 0)
      html.should match %r{<form}
      html.should match %r{How tall is Mt\. Everest\?}
    end

  end

  context 'given invalid problem' do

    it 'should raise a RenderError if answer is nil' do
      h = obj
      h[:answer] = nil
      q = parse(h.to_json)
      q.should_not be_valid
      expect { q.render(index: 0) }.to raise_error(Aladdin::Render::RenderError)
    end

  end

end
