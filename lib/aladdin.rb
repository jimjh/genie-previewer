# ~*~ encoding: utf-8 ~*~
require 'sinatra'
require 'zurb-foundation'
require 'albino'
require 'haml'
require 'redcarpet'
require 'htmlentities'
require 'sanitize'
require 'json'
require 'active_support/core_ext/hash'

require 'aladdin/constants'
require 'aladdin/config'
require 'aladdin/support'
require 'aladdin/render/markdown'

# Aladdin is a gem that lesson authors can use to preview and test their
# lessons locally.
module Aladdin
  class << self

    include Support::Logger
    attr_accessor :config

    # Launches the tutorial app using 'thin' as the default webserver.
    # @option opts [String] from        path to author's markdown documents;
    #                                   defaults to the current working directory
    def launch(opts = {})
      root = opts[:from] || Dir.pwd
      @config = Config.new root
      Aladdin::App.set :views, Aladdin::VIEWS.merge(markdown: root)
      Aladdin::App.run!
    rescue => e
      logger.error e.message
    end

  end
end

require 'aladdin/app'
