Given /^that a feature server is running$/ do
  server = File.dirname(__FILE__) + "/../resources/feature_server"
  ScenarioProcess.run "ruby #{server}", 'feature_server'
end
