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
      msg = "We expected a manifest file at #{dir + Spirit::MANIFEST}"
      expect { Aladdin::Config.new dir }.to raise_error Aladdin::ConfigError, /#{msg}/
    end
  end

  context 'given an unreadable manifest' do
    before(:each) { IO.write dir + Spirit::MANIFEST, '{}', perm: 0333 }
    it 'raises a ConfigError' do
      msg = "We found a manifest file at #{dir + Spirit::MANIFEST}, but couldn't open it"
      expect { Aladdin::Config.new dir }.to raise_error Aladdin::ConfigError, /#{msg}/
    end
  end

  context 'given an invalid manifest' do
    before(:each) { IO.write dir + Spirit::MANIFEST, 'abc:def' }
    it 'raises a ConfigError' do
      msg = "We found a manifest file at #{dir + Spirit::MANIFEST}, but couldn't parse it"
      expect { Aladdin::Config.new dir }.to raise_error Aladdin::ConfigError, /#{msg}/
    end
  end

  context 'given a good manifest' do
    before(:each) { IO.write dir + Spirit::MANIFEST, {title: '2.0'}.to_yaml }
    its([:title]) { should eq '2.0' }
  end

end

