# ~*~ encoding: utf-8 ~*~
module Aladdin

  # laddin-render module for all of Laddin's rendering needs.
  module Render

    # HTML Renderer for Markdown.
    # It creates pygmentized code blocks, supports hard-wraps, and only
    # generates links for protocols which are considered safe.
    # @see http://github.github.com/github-flavored-markdown/
    class HTML < ::Redcarpet::Render::HTML

      @sanitize = Aladdin::Sanitize.new
      class << self; attr_reader :sanitize; end

      # Creates a new HTML renderer.
      # @param [Hash] options        described in the RedCarpet documentation.
      def initialize(options = {})
        super options.merge(hard_wrap: true, safe_links_only: true)
      end

      # Pygmentizes code blocks.
      # @param [String] code        code block contents
      # @param [String] marker      name of language, for syntax highlighting
      # @return [String] highlighted code
      def block_code(code, marker)
        language, type = marker.split ':'
        case type
        when 'demo'
          puts Albino.colorize code, language
        else Albino.colorize code, language
        end
      end

      # Sanitizes the final document.
      # @param [String] document    html document
      # @return [String] sanitized document
      def postprocess(document)
        HTML.sanitize.clean document
      end

    end

  end
end
