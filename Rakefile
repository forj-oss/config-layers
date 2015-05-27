require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rubocop/rake_task' unless RUBY_VERSION.match(/1\.8/)
require 'rdoc/task'
require 'json'

task :default => [:lint, :spec]

desc 'Run all specs (locally + docker).'
task :spec => [:spec_local, :spec18]

desc 'Run acceptance test (docker - specs).'
task :acceptance => [:spec18]

desc 'Run the specs.'
RSpec::Core::RakeTask.new(:spec_local) do |t|
  t.pattern = 'spec/*_spec.rb'
  t.rspec_opts = '-f doc'
end

desc 'Generate lorj documentation'
RDoc::Task.new do |rdoc|
  rdoc.main = 'README.md'
  rdoc.rdoc_files.include('README.md', 'lib', 'example', 'bin')
end

if RUBY_VERSION.match(/1\.8/)
  desc 'no lint with ruby 1.8'
  task :lint
else
  desc 'Run RuboCop on the project'
  RuboCop::RakeTask.new(:lint) do |task|
    task.formatters = ['progress']
    task.verbose = true
    task.fail_on_error = true
  end
end

# rubocop: disable Style/SpecialGlobalVars

desc 'Run spec with docker for ruby 1.8'
task :spec18 do
  begin
    `docker`
  rescue
    puts 'Unable to run spec against ruby 1.8: docker not found'
  else
    system('build/build_with_proxy.sh -t ruby/1.8')
    image_id = `docker images ruby/1.8`.split("\n")[1].split[2]
    res = `docker inspect -f '{{json .}}' config_layers`
    c_img = ''
    c_img = JSON.parse(res)['Image'][0..11] if $?.exitstatus == 0

    if $?.exitstatus == 0 && image_id == c_img
      system('docker start -ai config_layers')
    else
      `docker rm config_layers` if $?.exitstatus == 0
      system('docker run -it --name config_layers -v '\
             '$(pwd):/src -w /src ruby/1.8 /tmp/bundle.sh')
    end
  end
end

task :build => [:lint, :spec]
