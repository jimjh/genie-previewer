# ~*~ encoding: utf-8 ~*~
module Aladdin

  module Render

    # Renders a single question. This class doesn't do anything useful; use the
    # child classes (e.g. {Aladdin::Render::MCQ}) instead. Child classes should
    # override {#valid?} and provide a +TEMPLATE+ string constant.
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
      # @comment FIXME should I generate this at runtime?
      FORMATS = ['Mcq', 'Short', 'Table']

      class << self

        # Parses the given text for questions and answers. If the given text
        # does not contain valid JSON or does not contain the format key, raises
        # an {Aladdin::Render::ParseError}.
        # @param [String] text          markdown text
        def parse(text)
          json = JSON.parse text
          if json.is_a?(Hash) and json.has_key?(FORMAT)
            get_instance(json)
          else raise ParseError.new("Expected a JSON object containing the #{FORMAT} key.")
          end
        rescue JSON::JSONError => e
          raise ParseError.new(e.message)
        end

        # Dynamically creates accessor methods for JSON values.
        # @example
        #   accessor :id
        def accessor(*args)
          args.each { |arg| define_method(arg) { @json[arg] } }
        end

        private

        # @return [Question] question
        def get_instance(json)
          format = json[FORMAT].capitalize
          if FORMATS.include?(format)
            Aladdin::Render.const_get(format).new json
          else raise ParseError.new('Unrecognized format: %p' % format)
          end
        end

      end

      accessor ID, *KEYS

      # Creates a new question from the given JSON.
      def initialize(json)
        @json = json
        @json[ID] ||= SecureRandom.uuid
      end

      # Renders the given question using {#template}.
      # @comment TODO: should probably show some error message in the preview,
      # so that the author doesn't have to read the logs.
      def render
        raise RenderError.new('Invalid question.') unless valid?
        template.render Object.new, @json
      end

      private

      # @return [Boolean] true iff the parsed json contains a valid question.
      def valid?
        KEYS.all? { |key| @json.has_key? key }
      end

      # Retrieves the +template+ singleton.
      def template
        return @template unless @template.nil?
        file = File.join Aladdin::VIEWS[:haml], self.class::TEMPLATE
        @template = Haml::Engine.new(File.read file)
      end

    end

  end

end
