%w[rubygems rake rake/clean hoe fileutils newgem rubigen].each { |f| require f }
require File.expand_path(File.join(File.dirname(__FILE__) , '/lib/bumps_core'))
require File.expand_path(File.join(File.dirname(__FILE__) , 'environment.rb'))

Hoe.spec 'bumps' do
  
  self.version = Bumps::VERSION
  
  developer 'Brent Snook', 'brent@fuglylogic.com'
  self.summary = 'Remote feature management for Cucumber.'
  self.changes = paragraphs_of("History.txt", 0..1).join("\n\n")
  self.rubyforge_name = name
  
  [
    ['cucumber', ">= 0.3.103"],
    ['nokogiri','>= 1.3.3'],
  ].each { |dep| extra_deps << dep }
  
  [
    ['rspec', '>= 1.2.8'],
    ['newgem', ">= #{::Newgem::VERSION}"],
  ].each { |dep| extra_dev_deps << dep }

  self.clean_globs |= %w[**/.DS_Store tmp *.log]
  path = (rubyforge_name == name) ? rubyforge_name : "\#{rubyforge_name}/\#{name}"
  self.remote_rdoc_dir = File.join(path.gsub(/^#{rubyforge_name}\/?/,''), 'rdoc')
  self.rsync_args = '-av --delete --ignore-errors'
end

require 'cucumber/rake/task'
Cucumber::Rake::Task.new(:features) do |t|
  t.cucumber_opts = "features --format pretty"
end
task :features => :create_tmp

require 'newgem/tasks' # load /tasks/*.rake
Dir['tasks/**/*.rake'].each { |t| load t }

Rake::Task[:default].clear_prerequisites # clear out test-unit
task :default => [:spec, :features]