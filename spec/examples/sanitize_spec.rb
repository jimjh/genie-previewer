# ~*~ encoding: utf-8 ~*~
require 'spec_helper'

describe 'Using sanitize' do
  include Rack::Test::Methods

  # Only a small number of tests! Mostly trusting Sanitize, for now.
  context 'in a directory of malicious files' do

    before do
      dir = File.expand_path('sanitize', Test::DATA_DIR)
      Aladdin::App.set :views, Aladdin::VIEWS.merge(markdown: dir)
    end

    def app
      Aladdin::App
    end

    it 'should remove script tags' do
      get '/script'
      last_response.should be_ok
      last_response.body.should_not match /console\.log/
    end

    it 'should add no-follow' do
      get '/nofollow'
      last_response.should be_ok
      last_response.body.should match /rel="nofollow">Hello!<\/a>/
    end

    it 'should remove onclick' do
      get '/onclick'
      last_response.should be_ok
      last_response.body.should_not match /console\.log('I am dangerous.')/
    end

  end

end
