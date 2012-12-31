# ~*~ encoding: utf-8 ~*~

require "bundler/gem_tasks"
require 'rspec/core/rake_task'
require 'pathname'

RSpec::Core::RakeTask.new 'spec'

desc 'Run Tests'
task :default => :spec

namespace :assets do

  ASSETS = Pathname.new(Dir.pwd) + 'public' + 'assets'

  namespace :compile do

    desc 'Update javascript assets'
    task :js do
      input = Pathname.new '../genie-game/app/assets/javascripts'
      exec <<-eos
        coffee -j #{ASSETS + 'app.js'} -c #{input + 'verify.js.coffee'}
        uglifyjs --output #{ASSETS + 'app.min.js'} #{ASSETS + 'app.js'}
      eos
    end

    desc 'Update css assets'
    task :css do
      project = '../genie-game'
      Dir.chdir project do
        exec <<-eos
          bundle exec compass compile -e production --force --css-dir #{ASSETS}
        eos
      end
    end

  end

  task :compile => [:'compile:js', :'compile:css']

end
