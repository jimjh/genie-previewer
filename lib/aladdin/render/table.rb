# ~*~ encoding: utf-8 ~*~
module Aladdin

  module Render

    # Renders table questions marked up in JSON as HTML.
    #
    # The question should be given as a 2-dimensional array that represents the
    # table to be filled in. +"?"+ is a special token used in the question to
    # indicate cells that require student input.
    #
    # The answer should also be given as a 2-dimensional array. However, a
    # dummy token may be used in cells that do not require student input to
    # cut redundancy. In the example below, the +"-"+ token is used.
    #
    # @example
    #     {
    #       "format": "table",
    #       "question": [[0, "?", 2], [3, "?", 5]],
    #       "answer": [["-", 1, "-"],  ["-", 4, "-"]
    #     }
    class Table < Question

      # Name of template file for rendering table questions.
      TEMPLATE = 'table.haml'

      # Optional headings key.
      HEADINGS = 'headings'

      # Special token indicating that the cell should be filled in.
      FILL_ME_IN = '?'

      # Ensures that the +headings+ key exists.
      def initialize(json)
        json[HEADINGS] ||= nil
        super
      end

      # Checks if the given json contains a valid MCQ.
      # @return [Boolean] true iff the json contains a valid MCQ.
      def valid?
        super and has_valid_question? and has_valid_answer?
      end

      # Gets the expected answer, in www-form-urlencoded format.
      # @return [Hash] answers, as expected from student's form submission
      def answer
        if @answer.nil?
          @answer = {}
          question.each_with_index do |row, i|
            row.each_with_index do |cell, j|
              next unless Table.input? cell
              @answer[i.to_s] ||= {}
              @answer[i.to_s][j.to_s] = super[i][j].to_s
            end
          end
        end
        @answer
      end

      # @return [Boolean] true iff the given cell is an input cell
      def self.input?(cell)
        cell == FILL_ME_IN
      end

      private

      # @return [Boolean] true iff +question+ is a valid table.
      def has_valid_question?
        is_table?(question)
      end

      # @return [Boolean] true iff +answer+ is a valid table and has the same
      # number of rows as +question+.
      def has_valid_answer?
        ans = @json[ANSWER]
        is_table?(ans) and ans.size == question.size
      end

      # @return [Boolean] true iff +t+ is a 2-dimensional array.
      def is_table?(t)
        t.is_a? Array and t.all? { |row| row.is_a? Array }
      end

    end

  end

end

