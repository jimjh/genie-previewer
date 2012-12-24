# ~*~ encoding: utf-8 ~*~
module Aladdin

  module Render

    # Child classes should provide a +TEMPLATE+ string constant that contains
    # the path to the HAML file.
    class Template

      # Renders the given problem using {#view}.
      # @todo TODO should probably show some error message in the preview,
      # so that the author doesn't have to read the logs.
      def render(locals={})
        view.render Object.new, locals
      end

      private

      # Retrieves the +view+ singleton. If it is nil, initializes it from
      # +self.class.TEMPLATE+.
      # @return [Haml::Engine] haml engine
      def view
        return @view unless @view.nil?
        file = File.join Aladdin::VIEWS[:haml], self.class::TEMPLATE
        @view = Haml::Engine.new(File.read file)
      end

    end

  end

end
