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
