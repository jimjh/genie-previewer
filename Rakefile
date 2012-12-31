# ~*~ encoding: utf-8 ~*~

require "bundler/gem_tasks"
require 'rspec/core/rake_task'
require 'pathname'

RSpec::Core::RakeTask.new 'spec'

desc 'Run Tests'
task :default => :spec

namespace :assets do

  namespace :compile do

    desc 'Update javascript assets'
    task :js do
      input = Pathname.new '../genie-game/app/assets/javascripts'
      output = Pathname.new 'assets/__js'
      exec <<-eos
        coffee -j #{output + 'app.js'} -c #{input + 'verify.js.coffee'}
        uglifyjs --output #{output + 'app.min.js'} #{output + 'app.js'}
      eos
    end

  end

end
