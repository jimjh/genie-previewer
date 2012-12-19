# ~*~ encoding: utf-8 ~*~
module Aladdin

  module Render

    # Keeps track of document sections and renders a navigation bar.
    class Navigation

      # Creates a new navigation bar.
      def initialize
        file = File.join Aladdin::VIEWS[:haml], 'nav.haml'
        @template = Haml::Engine.new(File.read file)
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
      def render
        @template.render Object.new, sections: @sections
      end

    end

  end

end
