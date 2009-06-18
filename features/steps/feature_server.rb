Given /^that a feature server is running$/ do
  ScenarioProcess.run "ruby #{feature_server_script} #{pull_response_file}", 'feature_server'
end
