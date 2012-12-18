# ~*~ encoding: utf-8 ~*~
module Aladdin

  module Render

    # Renders multiple choice questions marked up in JSON as HTML.
    # @example
    #
    #     {
    #       "format": "mcq",
    #       "question": "How tall is Mount Everest?",
    #       "answer": "A",
    #       "options": {
    #         "A": "0",
    #         "B": "1"
    #       }
    #     }
    class Mcq < Question

      # Required key in JSON markup. Associated value should be a dictionary of
      # label -> choices.
      OPTIONS = 'options'

      # Retrieves the +mcq+ singleton.
      def template
        return @mcq unless @mcq.nil?
        template = File.join(Aladdin::VIEWS[:haml], 'mcq.haml')
        @mcq = Haml::Engine.new(File.read template)
      end

      # Checks if the given json contains a valid MCQ.
      # @return [Boolean] true iff the json contains a valid MCQ.
      def is_valid?
        super and
          @json.has_key?(OPTIONS) and
          @json[QUESTION].is_a? String and
          @json[ANSWER].is_a? String and
          @json[OPTIONS].is_a? Hash
      end

    end

  end

end
