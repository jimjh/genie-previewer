# ~*~ encoding: utf-8 ~*~
require 'spec_helper'

describe 'New' do

  context 'given lesson directory' do

    before(:all) { @dir = Dir.mktmpdir }
    after(:all) { FileUtils.remove_entry_secure @dir }

    it 'should copy the skeleton files over' do

      args = ['new', @dir]
      require 'aladdin/commands'
      Aladdin::Commands.parse! args, verbose: false

      found = Dir.entries(@dir) - %w(. ..)
      Aladdin::Commands::New::FILES.each do |file|
        found.should include(file)
      end

      Aladdin::Commands::New::DOT_FILES.each do |file|
        found.should include('.' + file)
      end

    end

  end

  context 'given invalid directory' do

    it 'should raise an exception' do
      args = ['new', '/xxxx%syyyyy' % SecureRandom.uuid ]
      require 'aladdin/commands'
      expect { Aladdin::Commands.parse! args, verbose: false }.to raise_error
    end

  end

end
