# ~*~ encoding: utf-8 ~*~
require 'aladdin/support/core_ext/hash'

module Aladdin

  root = File.expand_path('../../..', __FILE__)

  # Paths to other parts of the library.
  PATHS = {
    root:     root,
    assets:   File.expand_path('assets', root),
    skeleton: File.expand_path('skeleton', root)
  }.to_struct.freeze

  # Paths to different types of views.
  VIEWS = {
    haml:     File.expand_path('views/haml', root),
    scss:     File.expand_path('views/scss', root),
    default:  File.expand_path('views', root)
  }

  # @todo TODO allow configuration?
  DATA_DIR = Dir.tmpdir

  # File extension for solution files.
  SOLUTION_EXT = '.sol'

end
