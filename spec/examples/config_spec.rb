require 'spec_helper'

describe 'Config' do

  context 'given a configuration file' do

    before :each  do
      @dir = Dir.mktmpdir
    end

    after :each do
      FileUtils.remove_entry_secure @dir
    end

    it 'should use the defaults if the file is empty' do
      IO.write File.join(@dir, Aladdin::Config::FILE), '{}'
      config = Aladdin::Config.new @dir
      config.should eql(Aladdin::Config::DEFAULTS)
    end

    it 'should raise a ConfigError if the file is missing' do
      expect { Aladdin::Config.new @dir }.to raise_error Aladdin::ConfigError
    end

    it 'should raise a ConfigError if the file is not readable' do
      file = File.join @dir, Aladdin::Config::FILE
      IO.write file, '{}', perm: 0333
      expect { Aladdin::Config.new @dir }.to raise_error Aladdin::ConfigError
      FileUtils.rm file
      IO.write file, '{}', perm: 0666
      expect { Aladdin::Config.new @dir }.to_not raise_error
    end

    it 'should raise a ConfigError if the file does not contain valid JSON' do
      IO.write File.join(@dir, Aladdin::Config::FILE), '{', perm: 0333
      expect { Aladdin::Config.new @dir}.to raise_error Aladdin::ConfigError
    end

    it 'should raise a ConfigError if the values have the incorrect type' do
      IO.write File.join(@dir, Aladdin::Config::FILE), {title: 2.0}.to_json
      expect { Aladdin::Config.new @dir}.to raise_error Aladdin::ConfigError
    end

    it 'should override the defaults with the user supplied values' do
      IO.write File.join(@dir, Aladdin::Config::FILE), {title: '2.0'}.to_json
      config = Aladdin::Config.new @dir
      config[:title].should eq '2.0'
    end

  end

end

