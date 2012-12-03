# ~*~ encoding: utf-8 ~*~
require 'securerandom'

module Aladdin

  # Student submission.
  #
  # == DANGER DANGER DANGER ==
  # Because it assumes that there is only one submission at a time, it's
  # unsuitable for production use. This class does not impose any security
  # restritions at all.
  class Submission

    SCRATCHSPACE = '.__ss'

    # Creates a new student submission.
    # @param [String] id      exercise ID
    # @param [Type]   type    quiz or code
    # @param [String] input   student input
    def initialize(id, type, input)
      @id, @type, @input = id, type, input
    end

    # Executes the verification script and returns the JSON-encoded results.
    # @example
    #     ./verify --id=0 --input=path/to/student/input
    def verify
      case @type
      when Type::CODE then verify_code
      when Type::QUIZ then verify_quiz
      end
    end

    private

    def verify_quiz
      # FIXME: rewrite?
      # FIXME: directory attacks
      solution = File.join Aladdin::DATA_DIR, "#{@id}.sol"
      (@input.chomp == IO.read(solution).chomp).to_json
    rescue
      return false.to_json
    end

    def verify_code
      scratchspace do
        # FIXME: catch errors
        filename = SecureRandom.uuid
        IO.write(filename, @input)
        bin = File.join '..', Aladdin.config['verify']['bin']
        `#{bin} --id=#{@id} --input=#{filename}`
        IO.read 'genie-results.json'
      end
    end

    def scratchspace
      enter_scratchspace
      results = yield
      exit_scratchspace
      return results
    end

    def enter_scratchspace
      # TODO: handle errors
      Dir.mkdir SCRATCHSPACE
      Dir.chdir SCRATCHSPACE
    end

    def exit_scratchspace
      # TODO: handle errors
      Dir.chdir '..'
      FileUtils.rm_rf SCRATCHSPACE
    end

    # Submission Type, for use as enum.
    module Type
      # Quiz Type
      QUIZ = 'quiz'
      # Code Type
      CODE = 'code'
    end

  end

end
