# ~*~ encoding: utf-8 ~*~
module Aladdin

  module Render

    # Renders a single question. This class doesn't do anything useful; use the
    # child classes (e.g. {Aladdin::Render::MCQ}) instead.
    class Question

      # Required key in JSON markup. Value indicates type of question.
      FORMAT = 'format'

      # Required key in JSON markup. Value contains question body.
      QUESTION = 'question'

      # Required key in JSON markup. Value contains answers.
      ANSWER = 'answer'

      # Optional key in JSON markup. Value contains question ID.
      ID = 'id'

      # Required keys.
      KEYS = [FORMAT, QUESTION, ANSWER]

      # Valid formats.
      FORMATS = ['Mcq']

      # Parses the given text for questions and answers. If the given text
      # does not contain valid JSON or does not contain the format key, raises
      # an {Aladdin::Render::ParseError}.
      # @param [String] text          markdown text
      def self.parse(text)
        json = JSON.parse text
        raise ParseError.new("#{FORMAT} is required.") unless json.has_key?(FORMAT)
        format = json[FORMAT].capitalize
        raise ParseError.new("#{format} is unrecognized") unless FORMATS.include?(format)
        Aladdin::Render.const_get(format).new json
      rescue JSON::JSONError => e
        raise ParseError.new(e.message)
      end

      # Dynamically creates accessor methods for JSON values.
      def self.accessor(*args)
        args.each { |arg| define_method(arg) { @json[arg] } }
      end

      accessor ID, *KEYS

      # Creates a new question from the given JSON.
      def initialize(json)
        @json = json
        @json[ID] = SecureRandom.uuid if @json[ID].nil?
      end

      # @return [Boolean] true iff the parsed json contains a valid question.
      def is_valid?
        KEYS.reduce(true) { |memo, key| memo && @json.has_key?(key) }
      end

      # Renders the given question using {template}.
      def render
        raise RenderError.new('Invalid question') unless is_valid?
        template.render Object.new, @json
      end

      # Retrieves the +template+ singleton.
      def template
        raise 'Not implemented.'
      end

    end

  end

end