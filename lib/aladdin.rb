# ~*~ encoding: utf-8 ~*~
require 'sinatra'
require 'zurb-foundation'
require 'albino'
require 'haml'
require 'redcarpet'

require 'aladdin/version'
require 'aladdin/render/markdown'

# Aladdin is for tutorial apps.
module Aladdin

  # Launches the tutorial app using 'thin' as the default webserver.
  # @option opts [String] from        path to author's markdown documents;
  #                                   defaults to the current working
  #                                   directory.
  def self.launch(opts = {})
    Aladdin::VIEWS[:markdown] = opts[:from] || '.'
    require 'aladdin/app'
    Aladdin::App.run!
  end

  # Converts a hash to struct.
  def self.to_struct(hash)
    Struct.new( *(k = hash.keys) ).new( *hash.values_at( *k ) )
  end
  private_class_method :to_struct

  # Paths to different types of views.
  VIEWS = {
    haml: File.expand_path('../../views/haml', __FILE__),
    scss: File.expand_path('../../views/scss', __FILE__),
    default: File.expand_path('../../views', __FILE__)
  }

  # Paths to other parts of the library.
  PATHS = to_struct(
    assets: File.expand_path('../../assets', __FILE__),
  ).freeze

end
