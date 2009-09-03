%w[rubygems rake rake/clean fileutils newgem rubigen].each { |f| require f }
require File.expand_path(File.dirname(__FILE__) + '/lib/bumps_core')

# Generate all the Rake tasks
# Run 'rake -T' to see list of generated tasks (from gem root directory)
$hoe = Hoe.new('bumps', Bumps::VERSION) do |p|
  p.developer 'Brent Snook', 'brent@fuglylogic.com'
  p.summary = %q{Remote feature management for Cucumber.}
  p.changes = p.paragraphs_of("History.txt", 0..1).join("\n\n")
  p.rubyforge_name = p.name
  p.extra_deps = [
    ['cucumber', ">= 0.3.99"],
    ['nokogiri','>= 1.1.1'],
  ]
  p.extra_dev_deps = [
    ['newgem', ">= #{::Newgem::VERSION}"],
    ['rspec', '>= 1.2.7'],
  ]

  p.clean_globs |= %w[**/.DS_Store tmp *.log]
  path = (p.rubyforge_name == p.name) ? p.rubyforge_name : "\#{p.rubyforge_name}/\#{p.name}"
  p.remote_rdoc_dir = File.join(path.gsub(/^#{p.rubyforge_name}\/?/,''), 'rdoc')
  p.rsync_args = '-av --delete --ignore-errors'
end

require 'newgem/tasks' # load /tasks/*.rake
Dir['tasks/**/*.rake'].each { |t| load t }

Rake::Task[:default].clear_prerequisites # clear out test-unit
task :default => [:spec, :features]