# ~*~ encoding: utf-8 ~*~
require 'sinatra'
require 'spirit'
require 'spirit/tilt/template'
require 'aladdin/submission'

module Aladdin

  # Sinatra app that serves the lesson preview. Should be able to use this in a
  # config.ru file or as middleware. Authors should launch the app using the
  # +bin/aladdin+ executable.
  class App < Sinatra::Base
    extend Support::OneOfPattern

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
        set :public_folder, Aladdin::PATHS.public
        set :static_paths, Proc.new { Aladdin.config[:static_paths] }
      end

      # Registers redcarpet2 and configures aladdin's markdown renderer.
      # @return [void]
      def configure_markdown
        Tilt.register Spirit::Tilt::Template, *%w(markdown mkd md)
        set :markdown, layout: :layout, layout_engine: :haml
        set :haml,     escape_html: true, format: :html5
      end

    end

    # Calls the given +block+ and invokes +pass+ on error.
    def render_or_pass(&block)
      begin yield
      rescue Exception => e
        logger.error e.message
        pass
      end
    end

    enable :logging
    configure_views
    configure_markdown
    configure_assets

    get one_of(settings.static_paths) do |path|
      send_file File.join(settings.root, path)
    end

    get '/*' do |path|
      pass if path.starts_with? '__sinatra__'
      path = path.empty? ? :index : path.to_sym
      render_or_pass { markdown(path, locals: Aladdin.config) }
    end

    post '/verify/:type/:id' do
      input = request.body.read
      content_type :json
      Submission.new(params[:id], params[:type], params, input, logger).verify
    end

  end

end
