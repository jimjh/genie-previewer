# ~*~ encoding: utf-8 ~*~
require 'active_support/core_ext/logger'

module Aladdin

  module Support

    # Provides a convenient global logger.
    # @example
    #   class X
    #     include Logger
    #     def x; logger.info "hey"; end
    #   end
    # @todo FIXME allow configuration
    module Logger

      # Global logger.
      LOGGER = ::Logger.new(STDOUT)

      # Retrieves the global logger.
      def logger
        Logger::LOGGER
      end

    end

  end

end
