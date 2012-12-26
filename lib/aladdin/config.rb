# ~*~ encoding: utf-8 ~*~

module Aladdin

  # Raised when there is a configuration error.
  class ConfigError < StandardError; end

  # Configuration options for Aladdin.
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
      path = File.expand_path FILE, root
      case
      when (not File.exist? path)
        raise ConfigError.new("We couldn't find a manifest file at #{path}")
      when (not File.readable? path)
        raise ConfigError.new("We found a manifest file at #{path}, but " +
          "couldn't read it. Please ensure that the permissions are set " +
          "correctly.")
      else
        config = DEFAULTS.deep_merge ::JSON.parse(File.read path)
        super nil
        merge! config
      end
    rescue ::JSON::JSONError => e
      raise ConfigError.new e.message
    end

  end

end
