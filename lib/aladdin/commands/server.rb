# ~*~ encoding: utf-8 ~*~
require 'aladdin'
require 'optparse'

module Aladdin

  module Commands

    # @example
    #   $> aladdin server path/to/lesson/root
    module Server

      def parse!
        opt_parser = OptionParser.new do |opts|
          opts.banner = "Usage: aladdin server [options] [LESSON_PATH]"
        end
        opt_parser.parse!
      end

      extend self

      Commands.register do
        def server
          Server.parse!
          Aladdin.launch from: ARGV[0]
        end
      end

    end

  end

end
