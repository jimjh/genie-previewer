# ~*~ encoding: utf-8 ~*~
require 'aladdin/constants'
require 'aladdin/config'
require 'aladdin/support'

module Aladdin
  extend self

  attr_accessor :config

  # Prepares to launch the previewer app by configuring sinatra.
  # @option opts [String] from (Dir.pwd)   path to author's markdown documents
  def prepare(opts = {})
    root = opts[:from] || Dir.pwd
    @config = Config.new root
    require 'aladdin/app'
    Aladdin::App.set :root, root
    Aladdin::App.set :views, Aladdin::VIEWS.merge(markdown: root)
  end

  # Launches the previewer app.
  def launch(opts = {})
    prepare opts
    Aladdin::App.run!
  rescue => e
    puts e.message
  end

end

