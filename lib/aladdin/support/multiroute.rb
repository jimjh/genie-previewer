# ~*~ encoding: utf-8 ~*~
module Aladdin

  module Support

    # Sinatra route matcher that matches mutltiple paths given in an array.
    class OneOfMatcher

      Match = Struct.new(:captures)

      # Creates a new matcher for +routes+.
      # @param [Array] routes           array of static paths
      def initialize(routes)
        @routes = routes.map { |r| '/' + r }
        @captures = Match.new []
      end

      # Matches +routes+ against +str+.
      def match(str)
        @captures[:captures] = [str]
        @captures if @routes.any? { |r| str.starts_with? r }
      end

    end

    # Sinatra route matcher that matches mutltiple paths given in an array.
    module OneOfPattern
      # @example
      #   get one_of(%w(x y z)) do
      #     puts 'Hello!'
      #   end
      def one_of(routes)
        OneOfMatcher.new routes
      end
    end

  end

end
