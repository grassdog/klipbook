# encoding: utf-8

require "bundler/gem_tasks"

require "rspec/core/rake_task"
require 'cucumber/rake/task'

desc 'Run specs'
RSpec::Core::RakeTask.new(:spec)

Cucumber::Rake::Task.new(:features) do |t|
  t.cucumber_opts = '--format pretty'
end

desc 'Default: run specs'
task :default => [ :spec, :features ]

