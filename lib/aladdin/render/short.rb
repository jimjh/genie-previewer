# ~*~ encoding: utf-8 ~*~
module Aladdin

  module Render

    # Renders short questions marked up in JSON as HTML.
    # @example
    #
    #     {
    #       "format": "short",
    #       "question": "What is the most commonly used word in English?",
    #       "answer": "the"
    #     }
    class Short < Question

      # Name of template file for rendering short answer questions.
      TEMPLATE = 'short.haml'

      # Checks if the given json contains a valid MCQ.
      # @return [Boolean] true iff the json contains a valid MCQ.
      def is_valid?
        super and
          @json[QUESTION].is_a? String and
          not @json[ANSWER].empty?
      end

      private

      # @return [String] name of template file for this question format
      def template_file
        TEMPLATE
      end

    end

  end

end

