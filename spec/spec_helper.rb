# ~*~ encoding: utf-8 ~*~
require 'rubygems'
require 'bundler/setup'

begin Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems."
  exit e.status_code
end

module Test
  ROOT = File.dirname __FILE__
  DATA_DIR = File.expand_path 'data', ROOT
end

# add gem and current dir to load path
$LOAD_PATH.unshift File.join(Test::ROOT, '..', 'lib')
$LOAD_PATH.unshift Test::ROOT

# configure test environment
require 'aladdin'
require 'rspec'
require 'rack/test'
ENV['RACK_ENV'] = 'test'

# Redirects stderr and stdout to /dev/null.
def silence_output
  @orig_stderr = $stderr
  @orig_stdout = $stdout

  # redirect stderr and stdout to /dev/null
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
  config.after(:all) { enable_output }
end

require_relative 'shared/parse_context'
