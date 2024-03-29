# ~*~ encoding: utf-8 ~*~
require 'securerandom'

module Aladdin

  # Student submission.
  #
  # == DANGER DANGER DANGER ==
  # The scratchspace code assumes that there is only one submission at a time,
  # it's unsuitable for production use. It does not impose any security
  # restrictions at all.
  class Submission
    include Support::WeakComparator

    SCRATCHSPACE = '.__ss'

    # Creates a new student submission.
    # @param [String] id      exercise ID
    # @param [Type]   type    problem or code
    # @param [Hash]   params  form values
    # @param [String] input   student input
    def initialize(id, type, params, input, logger)
      @id, @type, @params, @input, @logger = id, type, params, input, logger
    end

    # Verifies the student's submission.
    def verify
      case @type
      when Type::CODE then verify_code
      when Type::PROBLEM then verify_problem
      end
    end

    private

    attr_reader :logger

    # Verifies problem answers by comparing the submitted answer against the
    # answer in the solution file.
    # @return [String] (json-encoded) true iff the submitted answer is correct.
    def verify_problem
      id = @id.gsub File::SEPARATOR, '' # protect against directory attacks
      solution = File.expand_path id + Spirit::SOLUTION_EXT, Spirit::SOLUTION_DIR
      File.open(solution, 'rb') { |f| same? @params['answer'], Marshal.restore(f) }.to_json
    rescue => e
      logger.warn e.message
      false.to_json
    end

    # Executes the verification script and returns the JSON-encoded results.
    # @example
    #     ./verify --id=0 --input=path/to/student/input
    def verify_code
      scratchspace do
        # FIXME: catch errors
        filename = SecureRandom.uuid
        IO.write(filename, @input)
        bin = File.join '..', Aladdin.config[:verify]['bin']
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
      # Problem Type
      PROBLEM = 'problem'
      # Code Type
      CODE = 'code'
    end

  end

end
