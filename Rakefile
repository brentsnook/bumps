%w[rubygems rake rake/clean hoe fileutils newgem rubigen].each { |f| require f }
['/lib/bumps_core', 'environment'].each do |f|
  require File.expand_path(File.join(File.dirname(__FILE__) , f))
end

Hoe.spec 'bumps' do
  self.version = Bumps::VERSION
  developer 'Brent Snook', 'brent@fuglylogic.com'
  self.readme_file = 'README.rdoc'
  self.clean_globs |= %w[**/.DS_Store tmp *.log]
  self.rsync_args = '-av --delete --ignore-errors' # is this needed?
  
  self.extra_deps = [
    ['cucumber', ">= 0.3.104"],
    ['nokogiri','>= 1.3.3'],
  ]
  
  self.extra_dev_deps = [
    ['rspec', '>= 1.2.8'],
    ['newgem', ">= #{::Newgem::VERSION}"],
    ['sinatra', '>=0.9.4'],
  ]
end

require 'cucumber/rake/task'
Cucumber::Rake::Task.new(:features) do |t|
  t.cucumber_opts = "features --format pretty"
end
task :features => :create_tmp

require 'newgem/tasks' # load /tasks/*.rake
Dir['tasks/**/*.rake'].each { |t| load t }

# IS THIS NEEDED?
Rake::Task[:default].clear_prerequisites # clear out test-unit
task :default => [:spec, :features]