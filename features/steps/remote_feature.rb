When /^I run all remote features$/ do
  pickle_command = File.dirname(__FILE__) + "/../../bin/pickle"
  ScenarioProcess.run pickle_command, 'pickle'
end
