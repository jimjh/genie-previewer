# ~*~ encoding: utf-8 ~*~
require './lib/laddin/version'

Gem::Specification.new do |gem|

  # NAME
  gem.name          = "laddin"
  gem.version       = Laddin::VERSION
  spec.platform     = Gem::Platform::RUBY
  spec.required_ruby_version = '>= 1.9.2'

  # LICENSES
  gem.license       = 'MIT'
  gem.authors       = ["Jiunn Haur Lim"]
  gem.email         = ["codex.is.poetry@gmail.com"]
  gem.summary       = %q{A simple tutorial generator for markdown documents.}
  gem.description   = %q{A simple tutorial generator for markdown documents.}
  gem.homepage      = "https://github.com/jimjh/laddin"

  # PATHS
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = %w[lib]
  gem.files         = %w[LICENSE README.md] + Dir.glob('lib/**/*.rb')

  gem.add_dependency 'sinatra', '~> 1.3'
  gem.add_dependency 'zurb-foundation', '~> 3.2'
  gem.add_dependency 'thin', '~> 1.5'
  gem.add_dependency 'haml', '~> 3.1'
  gem.add_dependency 'redcarpet', '~> 2.2'
  gem.add_dependency 'albino', '~> 1.3'

  # DOCUMENTATION
  gem.add_development_dependency 'yard', '~> 0.8.3'

end
