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
    # @param [String] input   student input
    def initialize(id, input)
      @id = id
      @input = input
    end

    # Executes the verification script and returns the JSON-encoded results.
    # @example
    #     ./verify --id=0 --input=path/to/student/input
    def verify
      scratchspace do
        # FIXME: catch errors
        filename = SecureRandom.uuid
        IO.write(filename, @input)
        bin = File.join '..', Aladdin.config['verify']['bin']
        `#{bin} --id=#{@id} --input=#{filename}`
        IO.read 'genie-results.json'
      end
    end

    private

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

  end

end
