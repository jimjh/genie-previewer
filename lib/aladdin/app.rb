# ~*~ encoding: utf-8 ~*~
require 'sinatra'
require 'zurb-foundation'
require 'aladdin/submission'

module Aladdin

  # Sinatra app that serves the tutorial. Should be able to use this in a
  # config.ru file or as middleware. Authors should launch the app using the
  # +bin/aladdin+ executable.
  # Adapted from https://github.com/jerodsanto/sinatra-foundation-skeleton/
  class App < Sinatra::Base
    extend Support::OneOfPattern

    # Default page
    INDEX = :index

    # Default markdown options.
    MARKDOWN_OPTIONS = {
      renderer:           Aladdin::Render::HTML,
      layout_engine:      :haml,
    }.merge MARKDOWN_EXTENSIONS

    class << self
      private

      # Configures path to the views, with different paths for different file
      # types.
      # @return [void]
      def configure_views
        helpers do
          def find_template(views, name, engine, &block)
            _, dir = views.detect { |k,v| engine == Tilt[k] }
            dir ||= views[:default]
            super(dir, name, engine, &block)
          end
        end
      end

      # Configures path to static assets in the public folder.
      # @return [void]
      def configure_assets
        set :public_folder, Aladdin::PATHS.assets
        set :static_paths, Proc.new { Aladdin.config[:static_paths] }
      end

      # Configures ZURB's compass to compile aladdin's scss assets.
      # @return [void]
      def configure_compass
        Compass.configuration do |config|
          config.http_path = '/'
          config.http_images_path = '/__img'
        end
        set :scss, Compass.sass_engine_options
      end

      # Registers redcarpet2 and configures aladdin's markdown renderer.
      # @return [void]
      def configure_markdown
        Tilt.register Tilt::RedcarpetTemplate::Redcarpet2, *%w(markdown mkd md)
        set :markdown, MARKDOWN_OPTIONS
        set :haml, escape_html: true, format: :html5
      end

    end

    # Calls the given +block+ and invokes +pass+ on error.
    # @param block        block to call within wrapper
    def render_or_pass(&block)
      begin return block.call
      rescue Exception => e
        logger.error e.message
        pass
      end
    end

    enable :logging
    configure_views
    configure_markdown

    configure :development, :test do
      configure_assets
      configure_compass
    end

    get '/__css/*.css' do |path|
      render_or_pass { scss path.to_sym }
    end

    get one_of(settings.static_paths) do |path|
      send_file File.join(settings.root, path)
    end

    get '/*' do |path|
      path = path.empty? ? INDEX : path.to_sym
      render_or_pass do
        markdown(path, locals: Aladdin.config)
      end
    end

    post '/verify/:type/:id' do
      input = request.body.read
      content_type :json
      Submission.new(params[:id], params[:type], params, input).verify
    end

  end

end
