require 'aladdin/render/sanitize'
require 'aladdin/render/error'
require 'aladdin/render/template'
require 'aladdin/render/image'
require 'aladdin/render/problem'
require 'aladdin/render/multi'
require 'aladdin/render/short'
require 'aladdin/render/table'
require 'aladdin/render/navigation'

# ~*~ encoding: utf-8 ~*~
module Aladdin

  # aladdin-render module for all of Laddin's rendering needs.
  module Render

    # HTML Renderer for Markdown.
    #
    # It creates pygmentized code blocks, supports hard-wraps, and only
    # generates links for protocols which are considered safe. Adds support for
    # embedded JSON, which are used to markup quizzes and tables. Refer to
    # {CONFIGURATION} for more details.
    #
    # @see http://github.github.com/github-flavored-markdown/
    class HTML < ::Redcarpet::Render::HTML
      include Aladdin::Mixin::Logger

      @sanitize = Aladdin::Sanitize.new
      @entities = HTMLEntities.new

      class << self; attr_reader :sanitize, :entities; end

      # Paragraphs that start and end with braces are treated as JSON blocks
      # and are parsed for questions/answers. If the paragraph does not contain
      # valid JSON, it will be rendered as a simple text paragraph.
      PROBLEM_REGEX = %r<^\s*{[^}]+}\s*$>

      # Paragraphs that only contain images are rendered differently.
      IMAGE_REGEX = %r{^\s*<img[^<>]+>\s*$}

      # Renderer configuration options.
      CONFIGURATION = {
        hard_wrap:          true,
        safe_links_only:    true,
      }

      # Creates a new HTML renderer.
      # @param [Hash] options        described in the RedCarpet documentation.
      def initialize(options = {})
        super options.merge(CONFIGURATION)
        exe_template = File.join(Aladdin::VIEWS[:haml], 'exe.haml')
        @exe, @nav = Haml::Engine.new(File.read exe_template), Navigation.new
        @prob, @img = 0, 0
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

      # Detects problem blocks and image blocks.
      # @param [String] text      paragraph text
      def paragraph(text)
        case text
        when PROBLEM_REGEX then problem(text)
        when IMAGE_REGEX then block_image(text)
        else p(text) end
      rescue Error => e # fall back to paragraph
        logger.warn e.message
        p(text)
      end

      # Increases all header levels by one and keeps track of document
      # sections.
      def header(text, level)
        level += 1
        html = h(text, level)
        if level == 2
          index = @nav << text
          html += "<a name='section_#{index}' data-magellan-destination='section_#{index}'/>"
        end
        html
      end

      # Sanitizes the final document.
      # @param [String] document    html document
      # @return [String] sanitized document
      def postprocess(document)
        HTML.sanitize.clean(@nav.render + document)
      end

      private

      # Prepares an executable code block.
      # @option opts [String] id        author-supplied ID
      # @option opts [String] raw       code to execute
      # @option opts [String] colored   syntax highlighted code
      # @return [String]
      def executable(opts)
        opts[:colored] + @exe.render(Object.new, id: opts[:id], raw: opts[:raw])
      end

      # Prepares a problem form. Raises {RenderError} or {ParseError} if the
      # given text does not contain valid json markup for a problem.
      # @param [String] json            JSON markup
      # @return [String] rendered HTML
      def problem(json)
        problem = Problem.parse(HTML.entities.decode json)
        problem.save! and problem.render(index: @prob += 1)
      end

      # Prepares a block image. Raises {RenderError} or {ParseError} if the
      # given text does not contain a valid image block.
      def block_image(text)
        image = Image.parse(text)
        image.render(index: @img += 1)
      end

      # Wraps the given text with header tags.
      # @return [String] wrapped text
      def h(text, level)
        "<h#{level}>#{text}</h#{level}>"
      end

      # Wraps the given text with paragraph tags.
      # @param [String] text            paragraph text
      # @return [String] wrapped text
      def p(text)
        '<p>' + text + '</p>'
      end

    end

  end
end
