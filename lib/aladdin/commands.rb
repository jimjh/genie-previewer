# ~*~ encoding: utf-8 ~*~
require 'aladdin/version'

Signal.trap('INT') { puts; exit(1) }

module Aladdin

  # Parses the command line arguments and invokes the relevant command.
  # @example Adding a command
  #   Commands.register do
  #     def new
  #       # do stuff
  #     end
  #   end
  module Commands

    # Path to USAGE file.
    USAGE = File.join File.dirname(__FILE__), *%w(commands/USAGE)

    # Registers a new command.
    def register(&block)
      extend Module.new(&block)
    end

    # Parses the command line arguments.
    def parse!(argv=ARGV, opts={})
      command = argv.shift
      case command
      when '--version', '-v'
        puts "Aladdin #{Aladdin::VERSION}"
        exit 0
      when nil, '--help', '-h'
        puts File.read USAGE
        exit 0
      else
        require_relative 'commands/new'
        require_relative 'commands/server'
        send command, argv, opts
      end
    rescue => e
      puts e.message
      puts File.read USAGE
      exit 1
    end

    extend self

  end

end
