require File.dirname(__FILE__) + "/../../lib/pickle"

gem 'cucumber'
require 'cucumber'
gem 'rspec'
require 'spec'

class CucumberWorld
  extend Forwardable
  def_delegators CucumberWorld, :configuration_file, :feature_directory

  def self.configuration_file
    @config_file = File.join File.dirname(__FILE__), '..', 'resources', 'pickle.yml'
  end

  def self.feature_directory
    relative_feature_dir = YAML::load(IO.read(configuration_file))['feature_directory']
    File.expand_path File.join(File.dirname(__FILE__), '..', '..', relative_feature_dir)
  end
end

Spec::Matchers.define :contain do |content| 
  match do |file| 
    @actual_content = File.read(file)
    @actual_content == content
  end
  
  failure_message_for_should do |file| 
    "\nexpected #{file} to contain #{content.inspect}\ngot #{@actual_content.inspect}\n"
  end
end 


World do
  CucumberWorld.new
end

Before do
  if File.exist? CucumberWorld.feature_directory
    FileUtils.remove_entry_secure CucumberWorld.feature_directory
  end
end

After do
  ScenarioProcess.kill_all
end