require File.dirname(__FILE__) + "/../../lib/pickle"

gem 'cucumber'
require 'cucumber'
gem 'rspec'
require 'spec'

class CucumberWorld
  extend Forwardable
  def_delegators CucumberWorld,
    :feature_server_script, :pull_response_file,
    :feature_report_file, :test_cucumber_directory

  def self.feature_report_file
    File.expand_path File.join(root, 'tmp', 'cucumber.out')
  end
  
  def self.feature_server_script
    File.expand_path File.join(root, 'features', 'resources', 'feature_server')
  end
  
  def self.pull_response_file
    File.expand_path File.join(root, 'features', 'resources', 'pull_all_features_response.xml')
  end  

  def self.test_cucumber_directory
    File.expand_path File.join(root, 'test_features')
  end
  
  def self.test_feature_directory
    File.expand_path File.join(test_cucumber_directory, 'features')
  end
  
  private
  
  def self.root
    File.expand_path File.join(File.dirname(__FILE__), '..', '..')
  end
end

World do
  CucumberWorld.new
end

Before do
  FileUtils.remove_entry_secure CucumberWorld.test_feature_directory
  FileUtils.mkdir CucumberWorld.test_feature_directory
  if File.exist? CucumberWorld.feature_report_file
    FileUtils.remove_entry_secure CucumberWorld.feature_report_file
  end
end

After do
  ScenarioProcess.kill_all
end