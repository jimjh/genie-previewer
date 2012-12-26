# ~*~ encoding: utf-8 ~*~
require 'logger'

module Aladdin

  # aladdin-mixin module contains all other mixin modules.
  module Mixin

    # @example
    #   require 'logger'
    #   logger.info "hey"
    module Logger

      # Global Logger.
      LOGGER = ::Logger.new STDOUT

      # Retrieves the global logger.
      def logger
        Logger::LOGGER
      end

    end

  end

end
