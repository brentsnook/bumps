require File.dirname(__FILE__) + "/../../lib/bumps"

gem 'cucumber'
require 'cucumber'
gem 'rspec'
require 'spec'

module CucumberWorld

  def feature_report_file
    File.expand_path File.join(root, 'tmp', 'cucumber.out')
  end
  
  def feature_report
    IO.read feature_report_file
  end
  
  def command_output
    IO.read command_output_file
  end
  
  def feature_server_script
    File.expand_path File.join(root, 'examples', 'feature_server')
  end

  def push_request_file
    File.expand_path File.join(root, 'tmp', 'results.xml')
  end
  
  def push_request
    IO.read push_request_file
  end
  
  def test_require_file
    File.expand_path File.join(test_cucumber_directory, 'env.rb')
  end
  
  def test_features_directory
    File.expand_path File.join(test_cucumber_directory, 'features')
  end
  
  def feature_server_command
    "ruby #{feature_server_script} #{remote_features_directory} #{push_request_file}"
  end  
  
  def each_feature
    Dir.glob("#{remote_features_directory}/**/*") do |feature_file|
      content = IO.read(feature_file).strip
      yield content.first.strip
    end
  end
  
  def clean
    FileUtils.remove_entry_secure test_features_directory
    FileUtils.mkdir test_features_directory
    [
      feature_report_file,
      push_request_file
    ].each do |file|
      FileUtils.remove_entry_secure file if File.exist? file
    end
  end
  
  private
  
  def root
    File.expand_path File.join(File.dirname(__FILE__), '..', '..')
  end
  
  def test_cucumber_directory
    File.expand_path File.join(root, 'test_features')
  end
  
  def command_output_file
    File.expand_path File.join(root, 'tmp', 'cucumber.log')
  end
  
  def remote_features_directory
    File.expand_path File.join(root, 'test_feature_content')
  end

end

World CucumberWorld

Before do
  clean
end

After do
  ScenarioProcess.kill_all
end