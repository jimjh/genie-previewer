# ~*~ encoding: utf-8 ~*~
require 'spec_helper'
require 'aladdin/commands'

describe 'Aladdin::Commands::New' do

  context 'given lesson directory' do

    before(:all) { @dir = Dir.mktmpdir }
    after(:all) { FileUtils.remove_entry_secure @dir }

    it 'copies the skeleton files over' do

      args = ['new', @dir]
      Aladdin::Commands.parse! args, verbose: false

      found = Dir.entries(@dir) - %w(. ..)
      Aladdin::Commands::New::FILES.each do |file|
        found.should include(file)
      end

      Aladdin::Commands::New::DOT_FILES.each do |file|
        found.should include('.' + file)
      end

    end

    it 'creates a valid lesson directory'

  end

  context 'given invalid directory' do

    it 'raises an exception' do
      args = ['new', '/xxxx%syyyyy' % SecureRandom.uuid ]
      expect { Aladdin::Commands.parse! args, verbose: false }.to raise_error
    end

  end

end
