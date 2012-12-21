# ~*~ encoding: utf-8 ~*~
module Aladdin

  module Render

    # Renders a single problem. This class doesn't do anything useful; use the
    # child classes (e.g. {Aladdin::Render::Multi}) instead. Child classes should
    # override {#valid?} and provide a +TEMPLATE+ string constant.
    class Problem

      # Required key in JSON markup. Value indicates type of problem.
      FORMAT = 'format'

      # Required key in JSON markup. Value contains question body.
      QUESTION = 'question'

      # Required key in JSON markup. Value contains answers.
      ANSWER = 'answer'

      # Optional key in JSON markup. Value contains problem ID.
      ID = 'id'

      # Required keys.
      KEYS = [FORMAT, QUESTION, ANSWER]

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

        # @return [Problem] problem
        def get_instance(json)
          klass = Aladdin::Render.const_get(json[FORMAT].capitalize)
          raise NameError.new unless klass < Problem
          klass.new(json)
        rescue NameError
          raise ParseError.new('Unrecognized format: %p' % json[FORMAT])
        end

      end

      accessor ID, *KEYS

      # Creates a new problem from the given JSON.
      def initialize(json)
        @json = json
        @json[ID] ||= SecureRandom.uuid
      end

      # Renders the given problem using {#template}.
      # @comment TODO: should probably show some error message in the preview,
      # so that the author doesn't have to read the logs.
      def render
        raise RenderError.new('Invalid problem.') unless valid?
        template.render Object.new, @json
      end

      # Saves the answer to a file on disk.
      # @comment TODO: should probably show some error message in the preview,
      # so that the author doesn't have to read the logs.
      def save!
        raise RenderError.new('Invalid problem.') unless valid?
        solution = File.join(Aladdin::DATA_DIR, id + Aladdin::DATA_EXT)
        File.open(solution, 'wb+') { |file| Marshal.dump answer, file }
      end

      private

      # @return [Boolean] true iff the parsed json contains a valid problem.
      def valid?
        KEYS.all? { |key| @json.has_key? key } and question.is_a? String
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
