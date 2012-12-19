# ~*~ encoding: utf-8 ~*~

Signal.trap('INT') { puts; exit(1) }

case ARGV.first
when '--version', '-v'
  puts "Aladdin #{Aladdin::VERSION}"
  exit(0)
when 'new'
  ARGV.shift
  require_relative 'commands/new'
when 'server'
  ARGV.shift
  require_relative 'commands/server'
else
  puts <<-eos
Usage:
  aladdin COMMAND [options]

Commands:
  new                 # generates the skeleton for a new lesson
  server              # launches a preview server

Aladdin Options:
  -v, [--version]     # show version number and quit
  -h, [--help]        # show this help message and quit
eos
  exit ['-h', '--help'].include?(ARGV.first) ? 0 : 1
end
