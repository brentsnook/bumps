%w[rubygems rake rake/clean hoe fileutils newgem rubigen].each { |f| require f }
require File.expand_path(File.dirname(__FILE__) + '/lib/bumps_core')

Hoe.spec 'bumps' do
  
  version = Bumps::VERSION
  
  developer 'Brent Snook', 'brent@fuglylogic.com'
  summary = %q{Remote feature management for Cucumber.}
  changes = paragraphs_of("History.txt", 0..1).join("\n\n")
  rubyforge_name = name
  extra_deps = [
    ['cucumber', ">= 0.3.103"],
    ['nokogiri','>= 1.3.3'],
  ]
  extra_dev_deps = [
    ['rspec', '>= 1.2.8'],
    ['newgem', ">= #{::Newgem::VERSION}"],
  ]

  clean_globs |= %w[**/.DS_Store tmp *.log]
  path = (rubyforge_name == name) ? rubyforge_name : "\#{rubyforge_name}/\#{name}"
  remote_rdoc_dir = File.join(path.gsub(/^#{rubyforge_name}\/?/,''), 'rdoc')
  rsync_args = '-av --delete --ignore-errors'
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