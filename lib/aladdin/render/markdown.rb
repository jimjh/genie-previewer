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
        language, type, id = marker.split ':'
        highlighted = Albino.colorize code, language
        case type
        when 'demo', 'test'
          executable id: id, raw: code, colored: highlighted
        else highlighted
        end
      end

      # Sanitizes the final document.
      # @param [String] document    html document
      # @return [String] sanitized document
      def postprocess(document)
        HTML.sanitize.clean document
      end

      private

      # Prepares an executable code block.
      # FIXME: take HTML out of the code.
      # @option opts [String] id        author-supplied ID
      # @option opts [String] raw       code to execute
      # @option opts [String] colored   syntax highlighted code
      # @return [String]
      def executable(opts)
        opts[:colored] +
          "<form id='ex_#{opts[:id]}'>" +
          "   <input type='hidden' class='ex-raw' value='#{opts[:raw]}'/>" +
          "   <input type='hidden' class='ex-id' value='#{opts[:id]}'/>" +
          "</form>" +
          "<a class='button run' href='#ex_#{opts[:id]}'>Run</a>"
      end

    end

  end
end
