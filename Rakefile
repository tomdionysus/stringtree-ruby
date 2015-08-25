require "bundler/gem_tasks"
require "rspec/core/rake_task"
require 'rdoc/task'

RDoc::Task.new do |rd|
  rd.main = "README.rdoc"
  rd.rdoc_files.include("README.md", "lib/**/*.rb")
  rd.rdoc_dir = "doc"
end

RSpec::Core::RakeTask.new(:spec)

task :default => :spec
