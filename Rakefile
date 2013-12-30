# encoding: utf-8

require 'rubygems'
require 'bundler/setup'
require 'rake'
require './lib/klipbook/version.rb'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  gem.name = 'klipbook'
  gem.homepage = 'https://github.com/grassdog/klipbook'
  gem.license = 'MIT'
  gem.summary = %Q{Klipbook creates a nice html summary of the clippings you've created on your Kindle.}
  gem.description = %Q{Process your Kindle clippings file to generate a nicely formatted compilation of the clippings of the books you've read}
  gem.email = 'ray.grasso@gmail.com'
  gem.authors = ['Ray Grasso']
  gem.version = Klipbook::VERSION
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = Klipbook::VERSION

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "klipbook #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

require 'rspec/core/rake_task'

desc 'Run specs'
RSpec::Core::RakeTask.new(:spec)

require 'cucumber/rake/task'
Cucumber::Rake::Task.new(:features) do |t|
  t.cucumber_opts = '--format pretty --tags ~@slow'
end

Cucumber::Rake::Task.new(:allfeatures) do |t|
  t.cucumber_opts = '--format pretty'
end

desc 'Default: run specs'
task :default => :spec

desc 'Travis build'
task :ci => [ :spec, :features ]
