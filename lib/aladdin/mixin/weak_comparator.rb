# ~*~ encoding: utf-8 ~*~
module Aladdin

  module Mixin

    # Provides a rich comparison with weak-typing.
    # @see #same?
    module WeakComparator

      # Compares +submitted+ against +saved+ for equality. Assumes that
      # - +saved+ is a ruby-marshalled value that carries rich type information
      # - +submitted+ is a user-submitted value that is either a string or an
      #   enumerable.
      #
      # If +saved+ is +true+, then it will accept any +submitted+ that begins
      # with 'T' or 't'. Similarly, if +saved+ is +false+, then it will accept
      # any +submitted+ that begins with 'F' or 'f'.
      #
      # @param [String, Enumerable] submitted
      # @param [String, Numeric, Boolean, Enumerable] saved
      # @return [Boolean] true iff +submitted+ matches +saved+.
      def same?(submitted, saved)
        case saved
        when Enumerable
          Enumerable === submitted and same_enum? submitted, saved
        when String then saved == submitted
        when Numeric then saved == JSON.parse(%|[#{submitted}]|).first
        when TrueClass, FalseClass then saved.to_s[0] == submitted.downcase[0]
        else false end
      rescue
        false
      end

      private

      # Compares two enumerables for equality. It checks that both +submitted+
      # and +saved+ have the same number of elements, and then compares each
      # pair of elements in order.
      #
      # @param [Enumerable] submitted
      # @param [Enumerable] saved
      # @return [Boolean] true iff +submitted+ matches +saved+.
      # @see #same?
      def same_enum?(submitted, saved)
        return false unless saved.count == submitted.count
        sub, sav = submitted.each_entry, saved.each_entry
        loop { return false unless same? sub.next, sav.next }
        true
      end

    end

  end

end
