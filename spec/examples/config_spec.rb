require 'spec_helper'

describe Aladdin::Config do

  let(:dir)    { Pathname.new Dir.mktmpdir }
  after(:each) { FileUtils.remove_entry_secure dir }

  subject      { Aladdin::Config.new(dir) }

  context 'given an empty manifest' do
    before(:each) { IO.write dir + Spirit::MANIFEST, '---' }
    it { should eql(Aladdin::Config::DEFAULTS) }
  end

  context 'missing manifest' do
    it 'raises a ConfigError' do
      expect { Aladdin::Config.new dir }.to raise_error Aladdin::ConfigError
    end
  end

  context 'given an unreadable manifest' do
    before(:each) { IO.write dir + Spirit::MANIFEST, '{}', perm: 0333 }
    it 'raises a ConfigError' do
      expect { Aladdin::Config.new dir }.to raise_error Aladdin::ConfigError
    end
  end

  context 'given a good manifest' do
    before(:each) { IO.write dir + Spirit::MANIFEST, {title: '2.0'}.to_yaml }
    it 'overrides the defaults with the user-supplied values' do
      config = Aladdin::Config.new dir
      config[:title].should eq '2.0'
    end
  end

end

