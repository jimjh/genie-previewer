require 'aladdin/render/sanitize'
require 'aladdin/render/error'
require 'aladdin/render/question'
require 'aladdin/render/mcq'
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
      QUESTION_REGEX = %r[^\s*{[^}]+}\s*$]

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
        @exe = Haml::Engine.new(File.read exe_template)
        @navigation = Navigation.new
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

      # Detects question blocks and renders options or text fields and renders
      # them as forms.
      # @param [String] text      paragraph text
      def paragraph(text)
        return p(text) unless text.match QUESTION_REGEX
        question = Question.parse(HTML.entities.decode text)
        solution = File.join(Aladdin::DATA_DIR, question.id + Aladdin::DATA_EXT)
        File.open(solution, 'wb+') { |f| Marshal.dump(question.answer, f) }
        question.render
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
          index = @navigation << text
          html += "<a name='section_#{index}' data-magellan-destination='section_#{index}'/>"
        end
        html
      end

      # Sanitizes the final document.
      # @param [String] document    html document
      # @return [String] sanitized document
      def postprocess(document)
        HTML.sanitize.clean(@navigation.render + document)
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
