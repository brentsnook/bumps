Given /^that a feature server is running$/ do
  ScenarioProcess.run feature_server_command, 'feature_server'
end

Given /^that a feature server is not running$/ do
  ScenarioProcess.kill feature_server_command
end

