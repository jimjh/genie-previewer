  # ~*~ encoding: utf-8 ~*~
require 'active_support/core_ext/hash'
require 'active_support/core_ext/string'
require 'spirit'

module Aladdin

  # Raised when there is a configuration error.
  class ConfigError < StandardError; end

  # Configuration options for Aladdin. Gets all of its values from
  # {::Spirit::MANIFEST}. Values in this file should not be trusted
  # because they are given by the user.
  class Config < Hash

    # Default configuration options.
    DEFAULTS = {
      verify: {
        'bin' => 'make',
        'arg_prefix' => ''
       },
      title: 'Lesson X',
      description: 'This is a placeholder description. You should provide your own',
      categories: [],
      static_paths: %w(images)
    }

    # Creates a new configuration from the file at the given path. Merges the
    # configuration hash parsed from the file with {DEFAULTS}. Raises
    # {ConfigError} if the file could not be read or parsed.
    # @param [String] root            path to lesson root
    def initialize(root)
      super nil
      @path = File.join root, Spirit::MANIFEST
      ensure_readable
      merge! DEFAULTS.deep_merge Spirit::Manifest.load_file @path
    rescue Spirit::Error => e
      not_parseable e
    end

    private

    # Raises {ConfigError} unless the configuration file exists and is
    # readable.
    def ensure_readable
      missing unless File.exist? @path
      not_readable unless File.readable? @path
    end

    def missing
      raise ConfigError, <<-eos.squish
        We expected a manifest file at #{@path}, but couldn't find it. Please
        ensure that you have a file named #{Spirit::MANIFEST} at the root
        of your lesson directory.
      eos
    end

    def not_readable
      raise ConfigError, <<-eos.squish
        We found a manifest file at #{@path}, but couldn't open it for reading.
        Please ensure that you have the permissions to read the file.
      eos
    end

    def not_parseable(e)
      raise ConfigError, <<-eos.strip_heredoc
      We found a manifest file at #{@path}, but couldn't parse it. The following error message was returned from the parser:
          #{e.message}
      eos
    end

  end

end
