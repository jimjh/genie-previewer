# ~*~ encoding: utf-8 ~*~
# @see ::Hash
class Hash

  # Returns a struct representation of the receiver.
  # @return [Struct] struct
  def to_struct
    Struct.new( *(k = keys) ).new( *values_at( *k ) )
  end

end
