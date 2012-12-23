# ~*~ encoding: utf-8 ~*~
require 'sinatra'
require 'zurb-foundation'
require 'albino'
require 'haml'
require 'redcarpet'
require 'htmlentities'
require 'sanitize'
require 'yaml'
require 'json'

require 'aladdin/mixin/logger'
require 'aladdin/submission'
require 'aladdin/render/markdown'

# Aladdin is a gem that tutorial authors can use to preview and test their
# tutorials locally.
module Aladdin

  # Name of configuration file.
  CONFIG_FILE = '.genie.yml'

  # Default configuration options.
  DEFAULT_CONFIG = {
    'verify' => {
      'bin' => 'make',
      'arg_prefix' => ''
     },
    'title' => 'Lesson X',
    'description' => 'This is a placeholder description. You should provide your own',
    'categories' => []
  }

  class << self

    attr_reader :config, :root

    # Launches the tutorial app using 'thin' as the default webserver.
    # @option opts [String] from        path to author's markdown documents;
    #                                   defaults to the current working directory
    def launch(opts = {})
      @root = opts[:from] || '.'
      configure
      Aladdin::App.set :views, Aladdin::VIEWS.merge(markdown: root)
      Aladdin::App.run!
    end

    private

    # Reads configuration options from +.genie.yml+ and merges it into
    # {DEFAULT_CONFIG}.
    def configure
      config_file = File.expand_path CONFIG_FILE, root
      config = File.exists?(config_file) ? YAML.load_file(config_file) : {}
      @config = DEFAULT_CONFIG.merge(config) { |k, l, r|
        (l.is_a?(Hash) and r.is_a?(Hash)) ? l.merge(r) : r
      }
    end

    # Converts a hash to struct.
    def to_struct(hash)
      Struct.new( *(k = hash.keys) ).new( *hash.values_at( *k ) )
    end

  end

  # Paths to different types of views.
  VIEWS = {
    haml:     File.expand_path('../../views/haml', __FILE__),
    scss:     File.expand_path('../../views/scss', __FILE__),
    default:  File.expand_path('../../views', __FILE__)
  }

  # Paths to other parts of the library.
  PATHS = to_struct(
    assets: File.expand_path('../../assets', __FILE__),
  ).freeze

  # File extension for solution files.
  DATA_EXT = '.sol'

  # @todo TODO allow configuration?
  DATA_DIR = Dir.tmpdir

end

require 'aladdin/app'
