require File.dirname(__FILE__) + "/../../lib/pickle"

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
    File.expand_path File.join(root, 'features', 'resources', 'feature_server')
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
    "ruby #{feature_server_script} #{pull_response_file} #{push_request_file}"
  end  
  
  def each_feature
    document = Nokogiri::XML(File.read pull_response_file)
    document.search('feature').each do |feature_element|
      yield feature_element.text.strip.first
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
  
  def pull_response_file
    File.expand_path File.join(root, 'features', 'resources', 'pull_all_features_response.xml')
  end

end

World CucumberWorld

Before do
  clean
end

After do
  ScenarioProcess.kill_all
end