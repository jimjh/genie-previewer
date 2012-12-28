# ~*~ encoding: utf-8 ~*~
require 'active_support/core_ext/hash'
require 'json'

module Aladdin

  # Raised when there is a configuration error.
  class ConfigError < StandardError; end

  # Configuration options for Aladdin. Gets all of its values from {FILE}.
  # Values in this file should not be trusted because they are given by the
  # user.
  class Config < Hash

    # Name of configuration file.
    FILE = 'manifest.json'

    # Default configuration options.
    DEFAULTS = {
      'verify' => {
        'bin' => 'make',
        'arg_prefix' => ''
       },
      'title' => 'Lesson X',
      'description' => 'This is a placeholder description. You should provide your own',
      'categories' => [],
      'static_paths' => %w(images)
    }

    # Creates a new configuration from the file at the given path. Merges the
    # configuration hash parsed from the file with {DEFAULTS}. Raises
    # {ConfigError} if the file could not be read or parsed.
    # @param [String] root            path to lesson root
    def initialize(root)
      @path = File.expand_path FILE, root
      ensure_readable
      super nil
      merge! DEFAULTS.deep_merge ::JSON.parse File.read @path
      ensure_valid
    rescue ::JSON::JSONError => e
      raise ConfigError.new e.message
    end

    private

    # Raises {ConfigError} unless the configuration file exists and is
    # readable.
    def ensure_readable
      missing unless File.exist? @path
      not_readable unless File.readable? @path
    end

    # Raises {ConfigError} unless the all of the values in the supplied
    # configuration have the same type as those in {DEFAULTS}.
    def ensure_valid(defaults=DEFAULTS, supplied=self)
      supplied.each do |key, value|
        bad_type(key, defaults[key], value) unless value.is_a? defaults[key].class
        ensure_valid(defaults[key], value) if Hash === value
      end
    end

    def missing
      raise ConfigError.new <<-eos.squish
        We expected a manifest file at #{@path}, but couldn't find it. Please
        ensure that you have a file named #{Aladdin::Config::File} at the root
        of your lesson directory.
      eos
    end

    def not_readable
      raise ConfigError.new <<-eos.squish
        We found a manifest file at #{@path}, but couldn't open it for reading.
        Please ensure that you have the permissions to read the file.
      eos
    end

    def bad_type(key, expected, actual)
      raise ConfigError.new <<-eos.squish
        The #{key} option in the manifest file should be a #{expected.class.name}
        instead of a #{actual.class.name}.
      eos
    end

  end

end
