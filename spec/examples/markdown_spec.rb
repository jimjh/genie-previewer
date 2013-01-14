# ~*~ encoding: utf-8 ~*~
require 'spec_helper'

describe 'Aladdin::App' do
  include Rack::Test::Methods

  context 'given a lesson directory' do

    include_context 'app'

    it 'maps URLs to their filenames' do
      get '/a'
      last_response.should be_ok
      last_response.content_type.should match %{^text/html}
      get '/b'
      last_response.should be_ok
      last_response.content_type.should match %{^text/html}
    end

    it 'renders HTML' do
      get '/a'
      last_response.body.should match %{<html}
      last_response.body.should match %{<h2}
      last_response.body.should match %{Hello World}
    end

    it 'returns a 404 for missing files' do
      get '/c'
      last_response.should be_not_found
      get '/assets/x.js'
      last_response.should be_not_found
    end

    it 'serves static assets' do
      js = 'foundation/jquery.js'
      get "/assets/#{js}"
      last_response.should be_ok
      last_response.content_type.should match %{^application/javascript}
      js = File.expand_path js, File.join(Test::ROOT, '..', 'public', 'assets')
      last_response.body.force_encoding('utf-8').should eql(File.read js)
    end

    it 'serves files at author\'s static paths' do
      get '/images/x.png'
      last_response.should be_ok
      last_response.content_type.should match %{^image/png}
    end

  end

end
