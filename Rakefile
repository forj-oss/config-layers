require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'rdoc/task'

task :default => [:lint, :spec]

desc 'Run the specs.'
RSpec::Core::RakeTask.new do |t|
  t.pattern = 'spec/*_spec.rb'
  t.rspec_opts = '-f doc'
end

desc 'Generate lorj documentation'
RDoc::Task.new do |rdoc|
  rdoc.main = 'README.md'
  rdoc.rdoc_files.include('README.md', 'lib', 'example', 'bin')
end

desc 'Run RuboCop on the project'
RuboCop::RakeTask.new(:lint) do |task|
  task.formatters = ['progress']
  task.verbose = true
  task.fail_on_error = true
end

task :build => [:lint, :spec]
