# ~*~ encoding: utf-8 ~*~
require 'aladdin'
require 'optparse'
require 'spirit/constants'

module Aladdin

  module Commands

    # @example
    #   $> aladdin new path/to/lesson/root
    module New

      # Array of skeleton files to be copied over.
      FILES     = ['images', Aladdin::Config::FILE, Spirit::INDEX_MD]

      # Array of dot files to be copied over and renamed.
      DOT_FILES = %w(gitignore)

      # Flags for {::FileUtils.cp_r}
      COPY_FLAGS = {verbose: true}

      # Copies skeleton files to given destination.
      # @param [String] dest          destination path
      # @param [Hash]   flags         options for {::FileUtils.cp_r}
      # @return [Void]
      def copy_files(dest, flags={})
        flags = COPY_FLAGS.merge flags
        paths = FILES.map { |file| path_to file }
        FileUtils.cp_r paths, dest, flags
        DOT_FILES.each do |file|
          FileUtils.cp_r path_to(file), File.join(dest, '.' + file), flags
        end
      end

      # Prefixes +file+ with the skeleton directory.
      # @param [String] file          name of file to resolve
      # @return [String] path
      def path_to(file)
        File.expand_path file, Aladdin::PATHS.skeleton
      end

      # Parses the command line arguments.
      # @param [Array] argv           command line arguments
      # @return [Void]
      def parse!(argv)
        opt_parser = OptionParser.new do |opts|
          opts.banner = "Usage: aladdin new [options] [LESSON_PATH]"
        end
        opt_parser.parse! argv
      end

      extend self

      Commands.register do
        def new(argv=ARGV, opts={})
          New.parse! argv
          New.copy_files(argv[0] || Dir.pwd, opts)
        end
      end

    end

  end

end
