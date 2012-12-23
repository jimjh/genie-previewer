# ~*~ encoding: utf-8 ~*~
require 'aladdin'
require 'optparse'

# Array of skeleton files to be copied over.
SKELETON_FILES = %w(.genie.yml index.md images)

opt_parser = OptionParser.new do |opts|
  opts.banner = "Usage: aladdin new [options] [LESSON_PATH]"
end
opt_parser.parse!

root = ARGV[0] || Dir.pwd

Dir.chdir File.join File.dirname(__FILE__), *%w(.. .. .. skeleton)
FileUtils.cp_r SKELETON_FILES, root, verbose: true
