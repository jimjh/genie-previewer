# ~*~ encoding: utf-8 ~*~
require 'aladdin'
require 'optparse'

module Aladdin

  module Commands

    # @example
    #   $> aladdin server path/to/lesson/root
    module Server

      # Parses the command line arguments.
      # @param [Array] argv           command line arguments
      # @return [Void]
      def parse!(argv)
        opt_parser = OptionParser.new do |opts|
          opts.banner = "Usage: aladdin server [options] [LESSON_PATH]"
        end
        opt_parser.parse! argv
      end

      extend self

      Commands.register do
        def server(argv=ARGV, opts={})
          Server.parse! argv
          Aladdin.launch opts.merge(from: argv[0])
        end
      end

    end

  end

end
