# ~*~ encoding: utf-8 ~*~
module Aladdin

  module Render

    # The base exception for {Aladdin::Render} Errors
    class Error < StandardError; end

    # This exception is raised if a parse error occurs.
    class ParseError < Error; end

    # This exception is raised if a render error occurs.
    class RenderError < Error; end

  end

end
