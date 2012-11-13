# ~*~ encoding: utf-8 ~*~
module Aladdin

  # Sinatra app that serves the tutorial.
  # Adapted from https://github.com/jerodsanto/sinatra-foundation-skeleton/
  class App < Sinatra::Base

    class << self

      # Configures path to the views.
      def configure_views
        set :views, Aladdin::VIEWS
        helpers do
          def find_template(views, name, engine, &block)
            _, dir = views.detect { |k,v| engine == Tilt[k] }
            dir ||= views[:default]
            super(dir, name, engine, &block)
          end
        end
      end

      # Configures ZURB's compass to compile laddin's scss assets.
      def configure_compass
        Compass.configuration do |config|
          config.project_path = Aladdin::PATHS.assets
          config.http_path = '/'
          config.http_images_path = '/images'
        end
        set :scss, Compass.sass_engine_options
      end

      # Registers redcarpet2 and laddin's markdown renderer to be as close to
      # the github-flavored markdown as possible.
      def configure_markdown
        Tilt.register Tilt::RedcarpetTemplate::Redcarpet2, 'markdown', 'mkd', 'md'
        set :markdown,
          renderer: Aladdin::Render::HTML,
          no_intra_emphasis: true,
          tables: true,
          fenced_code_blocks: true,
          autolink: true,
          strikethrough: true,
          layout_engine: :haml
      end

    end

    configure do
      configure_views
      configure_compass
      configure_markdown
    end

    get '/' do
      haml :index
    end

    get '/stylesheets/*.css' do |path|
      content_type 'text/css', charset: 'utf-8'
      scss path.to_sym
    end

  end

end
