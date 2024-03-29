# ~*~ encoding: utf-8 ~*~
require './lib/aladdin/version'

Gem::Specification.new do |gem|

  # NAME
  gem.name          = 'aladdin'
  gem.version       = Aladdin::VERSION
  gem.platform      = Gem::Platform::RUBY
  gem.required_ruby_version = '>= 1.9.2'
  gem.requirements  = %q{pygments, python's syntax highlighter}

  # LICENSES
  gem.license       = 'MIT'
  gem.authors       = ['Jiunn Haur Lim']
  gem.email         = ['codex.is.poetry@gmail.com']
  gem.summary       = %q{A previewer for lessons written in the Genie Markup Language}
  gem.description   = %q{Parses the lesson files and launches a preview site.}
  gem.homepage      = "https://github.com/jimjh/genie-previewer"

  # PATHS
  gem.require_paths = %w[lib]
  gem.files         = %w[LICENSE README.md] +
                        Dir.glob('lib/**/*') +
                        Dir.glob('assets/**/*') +
                        Dir.glob('views/**/*') +
                        Dir.glob('bin/**/*') +
                        Dir.glob('skeleton/**/*')
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }

  # DEPENDENCIES
  gem.add_dependency 'sinatra',       '~> 1.3'
  gem.add_dependency 'activesupport', '~> 3.2.9'
  gem.add_dependency 'spirit'

  # DEVELOPMENT AND DOCUMENTATION
  gem.add_development_dependency 'yard',          '~> 0.8.3'
  gem.add_development_dependency 'debugger-pry',  '~> 0.1.1'
  gem.add_development_dependency 'rspec',         '~> 2.12.0'
  gem.add_development_dependency 'rake',          '~> 10.0.0'
  gem.add_development_dependency 'rack-test',     '~> 0.6.2'
  gem.post_install_message = "\e[0;34;49m" +
                             '» Use `easy_install Pygments` to install the ' +
                             'python syntax highlighter before using aladdin «' +
                             "\e[0m\n\n"

end
