# ~*~ encoding: utf-8 ~*~

module Aladdin

  # Raised when there is a configuration error.
  class ConfigError < StandardError; end

  # Configuration options for Aladdin.
  class Config

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
      'categories' => []
    }

    # Creates a new configuration from the file at the given path. Merges the
    # configuration hash parsed from the file with {DEFAULTS}. Raises
    # {ConfigError} if the file could not be read or parsed.
    # @param [String] root            path to lesson root
    def initialize(root)
      path = File.expand_path FILE, root
      case
      when (not File.exist? path)
        ConfigError.new("We couldn't find a manifest file at #{path}")
      when (not File.readable? path)
        ConfigError.new("We found a manifest file at #{path}, but couldn't " +
          "read it. Please ensure that the permissions are set correctly.")
      else
        config = JSON.parse(File.read path)
        @config = DEFAULTS.deep_merge config
      end
    rescue JSON::JSONError => e
      raise ConfigError.new e.message
    end

    # @return [Hash] a hash copy of the configuration options
    def to_hash
      @config.clone
    end

  end

end
