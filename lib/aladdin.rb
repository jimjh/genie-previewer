# ~*~ encoding: utf-8 ~*~
require 'json'
require 'active_support/core_ext/hash'
require 'active_support/core_ext/string'

require 'aladdin/constants'
require 'aladdin/config'
require 'aladdin/support'

# Aladdin is a gem that lesson authors can use to preview and test their
# lessons locally.
module Aladdin
  extend self

  attr_accessor :config

  # Launches the previewer app.
  # @option opts [String] from        path to author's markdown documents;
  #                                   defaults to the current working directory
  def launch(opts = {})
    root = opts[:from] || Dir.pwd
    @config = Config.new root
    require 'aladdin/app'
    Aladdin::App.set :root, root
    Aladdin::App.set :views, Aladdin::VIEWS.merge(markdown: root)
    Aladdin::App.run!
  rescue => e
    puts e.message
  end

end

