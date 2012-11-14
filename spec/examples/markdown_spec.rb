# ~*~ encoding: utf-8 ~*~
require 'spec_helper'

describe 'Launching aladdin' do
  include Rack::Test::Methods

  context 'in a simple directory of markdown documents' do

    before do
      dir = File.expand_path('markdown', Test::DATA_DIR)
      Aladdin::App.set :views, Aladdin::VIEWS.merge(markdown: dir)
    end

    def app
      Aladdin::App
    end

    it 'should map URLs to their filenames' do
      get '/a'
      last_response.should be_ok
      last_response.content_type.should match %{^text/html}
      get '/b'
      last_response.should be_ok
      last_response.content_type.should match %{^text/html}
    end

    it 'should render HTML' do
      get '/a'
      last_response.body.should match %{<h1>Hello World</h1>}
    end

    it 'should return a 404 for missing files' do
      get '/c'
      last_response.should be_not_found
      get '/javascripts/x.js'
      last_response.should be_not_found
    end

    it 'should compile scss to stylesheets' do
      # only for development/test mode
      get '/stylesheets/app.css'
      last_response.should be_ok
      last_response.content_type.should match %{^text/css}
    end

    it 'should serve static assets' do
      # only for development/test mode
      js = 'javascripts/foundation/jquery.js'
      get "/#{js}"
      last_response.should be_ok
      last_response.content_type.should match %{^application/javascript}
      js = File.expand_path js, File.join(Test::ROOT, '..', 'assets')
      last_response.body.force_encoding('utf-8').should eql(File.read js)
    end

  end

end
