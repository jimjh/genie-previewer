# ~*~ encoding: utf-8 ~*~
require 'rubygems'
require 'bundler/setup'
require 'pathname'

begin Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems."
  exit e.status_code
end

module Test
  ROOT = Pathname.new(__FILE__).dirname
end
$LOAD_PATH.unshift Test::ROOT + '..' + 'lib'

# configure test environment
require 'aladdin'
require 'rspec'
require 'rack/test'
ENV['RACK_ENV'] = 'test'

# Redirects stderr and stdout to /dev/null.
def silence_output
  @orig_stderr = $stderr
  @orig_stdout = $stdout
  $stderr = File.new('/dev/null', 'w')
  $stdout = File.new('/dev/null', 'w')
end

# Replace stdout and stderr so anything else is output correctly.
def enable_output
  $stderr = @orig_stderr
  $stdout = @orig_stdout
  @orig_stderr = nil
  @orig_stdout = nil
end

RSpec.configure do |config|
  config.before(:all) { silence_output }
  config.after(:all)  { enable_output }
end

require_relative 'shared/app_context'
