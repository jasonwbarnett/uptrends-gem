require 'bundler/gem_tasks'
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.test_files = FileList['spec/uptrends_extended/*_spec.rb']
  t.verbose = true
end

task :default => :test
