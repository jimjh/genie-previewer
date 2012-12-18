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
    #         "A": "452 inches",
    #         "B": "8.85 kilometers"
    #       }
    #     }
    class Mcq < Question

      # Required key in JSON markup. Associated value should be a dictionary of
      # label -> choices.
      OPTIONS = 'options'

      # Name of template file for rendering multiple choice questions.
      TEMPLATE = 'mcq.haml'

      # Checks if the given json contains a valid MCQ.
      # @return [Boolean] true iff the json contains a valid MCQ.
      def is_valid?
        super and
          question.is_a? String and
          answer.is_a? String and
          @json.has_key?(OPTIONS) and
          @json[OPTIONS].is_a? Hash
      end

    end

  end

end
