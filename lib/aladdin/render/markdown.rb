# ~*~ encoding: utf-8 ~*~
module Aladdin

  # laddin-render module for all of Laddin's rendering needs.
  module Render

    # HTML Renderer for Markdown.
    # It creates pygmentized code blocks, supports hard-wraps, and only
    # generates links for protocols which are considered safe.
    # @see http://github.github.com/github-flavored-markdown/
    class HTML < ::Redcarpet::Render::HTML

      # Creates a new HTML renderer.
      # @param [Hash] hash        described in the RedCarpet documentation.
      def initialize(options = {})
        super options.merge(hard_wrap: true, safe_links_only: true)
      end

      # Pygmentizes code blocks.
      # @param [String] code        code block contents
      # @param [String] language    name of language, for syntax highlighting
      def block_code(code, language)
        Albino.colorize code, language
      end

    end

  end
end
