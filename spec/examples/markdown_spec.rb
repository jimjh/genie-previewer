# ~*~ encoding: utf-8 ~*~
require 'spec_helper'

describe 'Launching aladdin' do
  include Rack::Test::Methods

  context 'in a simple directory of markdown documents' do

    let(:dir) { File.expand_path('markdown', Test::DATA_DIR) }
    include_context 'app'

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
      last_response.body.should match %{<h2}
      last_response.body.should match %{Hello World}
    end

    it 'should return a 404 for missing files' do
      get '/c'
      last_response.should be_not_found
      get '/__js/x.js'
      last_response.should be_not_found
    end

    it 'should compile scss to stylesheets' do
      # only for development/test mode
      get '/__css/app.css'
      last_response.should be_ok
      last_response.content_type.should match %{^text/css}
    end

    it 'should serve static assets' do
      # only for development/test mode
      js = 'foundation/jquery.js'
      get "/#{js}"
      last_response.should be_ok
      last_response.content_type.should match %{^application/javascript}
      js = File.expand_path js, File.join(Test::ROOT, '..', 'public')
      last_response.body.force_encoding('utf-8').should eql(File.read js)
    end

    it 'should serve files at author\'s static paths' do
      get '/images/x.png'
      last_response.should be_ok
      last_response.content_type.should match %{^image/png}
    end

  end

end
