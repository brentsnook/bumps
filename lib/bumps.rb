require File.expand_path(File.join(File.dirname(__FILE__), 'bumps_core'))

# Cucumber hook
AfterConfiguration do |config|
  Bumps::CucumberConfig.new(config).process!
  Bumps::Feature.pull
end