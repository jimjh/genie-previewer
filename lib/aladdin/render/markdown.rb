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

      # The portion of the string before the first colon will be regarded as
      # the choice label; the remaining portion of the string will become the
      # choice text. An optional space may be present after the colon.
      CHOICE_REGEX = %r[^([^:]+): ?(.+)$]

      # The string must have the following format:
      #
      #     ? [answer] question
      #
      # It must begin with a question mark, contain a pair of square
      # parentheses enclosing the answer, and some question text. The spaces
      # separating each component are optional.
      QUESTION_REGEX = %r[^\? ?\[([^\]]+)\] ?(.+)$]

      # File extension for solution files.
      EXT = '.sol'

      # Creates a new HTML renderer.
      # @param [Hash] options        described in the RedCarpet documentation.
      def initialize(options = {})
        super options.merge(hard_wrap: true, safe_links_only: true)
        quiz_template = File.join(Aladdin::VIEWS[:haml], 'quiz.haml')
        @quiz = Haml::Engine.new(File.read quiz_template)
        exe_template = File.join(Aladdin::VIEWS[:haml], 'exe.haml')
        @exe = Haml::Engine.new(File.read exe_template)
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

      # Detects quiz blocks and renders options or text fields and renders them
      # as forms.
      # @param [String] text      paragraph text
      def paragraph(text)
        return p(text) unless tokens = parse_question(text)
        id = SecureRandom.uuid
        IO.write File.join(Aladdin::DATA_DIR, id + EXT), tokens[:a]
        @quiz.render Object.new, tokens.update(id: id)
      end

      # Sanitizes the final document.
      # @param [String] document    html document
      # @return [String] sanitized document
      def postprocess(document)
        HTML.sanitize.clean document
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

      # Wraps the given text with paragraph tags.
      # @param [String] text            paragraph text
      # @return [String] wrapped text
      def p(text)
        '<p>' + text + '</p>'
      end

      # Parses the given array of lines for quiz choices and returns an array
      # of options.
      # @param [Array] lines          lines from markdown file
      # @return [Array] options
      def parse_choices(lines)
        lines.map { |line|
          match, label, option = *line.match(CHOICE_REGEX)
          {label: label, option: option} if match
        }.compact
      end

      # Parses the given text for quiz questions.
      # @param [String] text          markdown text
      # @return [Hash] tokens
      def parse_question(text)
        lines = text.split $/
        return nil unless question = lines.shift and
          tokens = question.match(QUESTION_REGEX)
        {q: tokens[2], a: tokens[1], choices: parse_choices(lines)}
      end

    end

  end
end
