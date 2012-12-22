# ~*~ encoding: utf-8 ~*~
module Aladdin

  module Render

    # Keeps track of document sections and renders a navigation bar.
    class Navigation < Template

      # HAML template for navigation bar
      TEMPLATE = 'nav.haml'

      # Creates a new navigation bar.
      def initialize
        @sections = []
      end

      # Adds a new section.
      # @param [String] heading      section heading
      # @return [Fixnum] section index
      def <<(heading)
        @sections << heading
        @sections.size - 1
      end

      # Renders the navigation bar in HTML.
      def render(locals={})
        super locals.merge(sections: @sections)
      end

    end

  end

end
