# ~*~ encoding: utf-8 ~*~
module Aladdin

  # Sinatra app that serves the tutorial. Should be able to use this in a
  # config.ru file or as middleware. Authors should launch the app using the
  # +bin/aladdin+ executable.
  # Adapted from https://github.com/jerodsanto/sinatra-foundation-skeleton/
  class App < Sinatra::Base

    # Default markdown options.
    MARKDOWN_OPTIONS = {
      renderer:           Aladdin::Render::HTML,
      no_intra_emphasis:  true,
      tables:             true,
      fenced_code_blocks: true,
      autolink:           true,
      strikethrough:      true,
      tables:             true,
      layout_engine:      :haml
    }

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
      end

      # Configures ZURB's compass to compile laddin's scss assets.
      # @return [void]
      def configure_compass
        Compass.configuration do |config|
          config.http_path = '/'
          config.http_images_path = '/images'
        end
        set :scss, Compass.sass_engine_options
      end

      # Registers redcarpet2 and laddin's markdown renderer to be as close to
      # the github-flavored markdown as possible.
      # @return [void]
      def configure_markdown
        Tilt.register Tilt::RedcarpetTemplate::Redcarpet2, 'markdown', 'mkd', 'md'
        set :markdown, MARKDOWN_OPTIONS
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

    get '/stylesheets/*.css' do |path|
      render_or_pass { scss path.to_sym }
    end

    get '/*' do |path|
      render_or_pass { markdown path.to_sym }
    end

  end

end
