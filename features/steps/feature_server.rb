require 'json'

Given /^that a feature server is running$/ do
  ScenarioProcess.run feature_server_command, 'feature_server'
end

Given /^that a feature server is not running$/ do
  ScenarioProcess.kill feature_server_command
end

Then /^JSON formatted feature results will be sent to the server$/ do
  JSON.parse(push_request)['features'].size.should == all_features.size
end

