# ~*~ encoding: utf-8 ~*~
require 'aladdin/support/core_ext/hash'

module Aladdin

  root = File.expand_path('../../..', __FILE__)

  # Paths to other parts of the library.
  PATHS = {
    root:     root,
    public:   File.expand_path('public', root),
    skeleton: File.expand_path('skeleton', root)
  }.to_struct.freeze

  # Paths to different types of views.
  VIEWS = {
    haml:     File.expand_path('views/haml', root),
    default:  File.expand_path('views', root)
  }

  require 'tmpdir'
  # @todo TODO allow configuration?
  DATA_DIR = Dir.tmpdir

  # Name of index file
  INDEX_MD   = 'index.md'

  # File extension for solution files.
  SOLUTION_EXT = '.sol'

end
