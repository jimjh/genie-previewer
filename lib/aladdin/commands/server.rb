# ~*~ encoding: utf-8 ~*~
require 'aladdin'
require 'optparse'

opt_parser = OptionParser.new do |opts|
  opts.banner = "Usage: aladdin server [options] [LESSON_PATH]"
end
opt_parser.parse!

Aladdin.launch from: ARGV[0]
