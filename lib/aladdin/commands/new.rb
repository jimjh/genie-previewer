# ~*~ encoding: utf-8 ~*~
require 'aladdin'
require 'optparse'

module Aladdin

  module Commands

    # @example
    #   $> aladdin new path/to/lesson/root
    module New

      # Path to the skeleton directory.
      SKELETON_DIR = File.join File.dirname(__FILE__), *%w(.. .. .. skeleton)

      # Array of skeleton files to be copied over.
      FILES     = %w(index.md images) << Aladdin::CONFIG_FILE

      # Array of dot files to be copied over and renamed.
      DOT_FILES = %w(gitignore)

      # Flags for {FileUtils.cp_r}
      COPY_FLAGS = {verbose: true}

      # Copies skeleton files to given destination.
      # @param [String] dest          destination path
      # @return [Void]
      def copy_files(dest)
        paths = FILES.map { |file| path_to file }
        FileUtils.cp_r paths, dest, COPY_FLAGS
        DOT_FILES.each do |file|
          FileUtils.cp_r path_to(file), File.join(dest, '.' + file), COPY_FLAGS
        end
      end

      # Prefixes +filename+ with {SKELETON_DIR}
      # @param [String] filename      name of file to resolve
      # @return [String] path
      def path_to(file)
        File.expand_path file, SKELETON_DIR
      end

      # Parses the command line arguments.
      # @return [Void]
      def parse!
        opt_parser = OptionParser.new do |opts|
          opts.banner = "Usage: aladdin new [options] [LESSON_PATH]"
        end
        opt_parser.parse!
      end

      extend self

      Commands.register do
        def new
          New.parse!
          New.copy_files(ARGV[0] || Dir.pwd)
        end
      end

    end

  end

end
