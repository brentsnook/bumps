Given /^that a feature server is running$/ do
  dir = File.dirname(__FILE__)
  server = dir + "/../resources/feature_server"
  @pull_response_file = File.expand_path File.join(dir, '..', 'resources', 'pull_all_features_response.xml')
  ScenarioProcess.run "ruby #{server} #{@pull_response_file}", 'feature_server'
end
